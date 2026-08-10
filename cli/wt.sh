# wt — git worktree helper that wraps wtm (worktree manager). bash + zsh.
#
# Worktrees live as sibling directories under a wtm-managed bare repo
# "container" (the parent of the git common dir), nested by their full branch
# name — e.g. branch feat/foo lives at <container>/feat/foo. `wtm` itself only
# runs from that container, but `wt` is meant to be run from anywhere inside the
# repo, so it derives the container and cd's for you — hence a sourced function,
# not a standalone script (a subprocess can't change the parent shell's cwd).
#
#   wt <name> [base] [--model <m>] [--permission-mode <p>]
#                      Go to worktree <name>. <name> is the full worktree name
#                      (e.g. feat/foo); a unique trailing segment (foo) also
#                      resolves. If it doesn't exist yet:
#                        - branch exists  -> check it out
#                        - otherwise      -> confirm, then create from <base>
#                      <base>, if not given explicitly, defaults to "main" —
#                      unless you're currently inside a worktree (not the bare
#                      container root), in which case it defaults to that
#                      worktree's branch instead; declining that prompt offers
#                      to create from "main" instead. After landing, activates
#                      the worktree's .venv and .env, and (inside kitty) opens
#                      the three-pane "Code" tab (nvim / claude / terminal).
#                      --model <m> and --permission-mode <p> are passed through
#                      to the claude pane; permission-mode defaults to "auto".
#   wt list            Table of every worktree: directory, lock flag, checked-out
#                      branch, last commit date + subject, and the branch's PR if
#                      GitHub has one (green open, gray draft, purple merged or
#                      closed). Newest commit first. Built straight from git +
#                      gh rather than `wtm list`, which only prints paths.
#   wt delete <name> [-f|--force]
#                      Delete a worktree and the matching local branch. Refuses
#                      if the worktree's checked-out branch doesn't match its
#                      path, or if the worktree is locked (supacode locks the
#                      ones it manages). -f/--force skips the branch check,
#                      unlocks first, and force-deletes.
#   wt pr              Check gh for a PR on the current branch and update the
#                      current kitty tab's title to reflect it.
#
# Knobs:  WT_NO_CODE=1        don't open the kitty Code tab
#         WT_AUTO_ACTIVATE=0  don't auto-activate .venv/.env in new worktree shells
#         WT_LIST_NO_PR=1     skip the gh lookup in `wt list` (offline / faster)

# Resolve the wtm bare-repo container for the current git repo.
# Prints the absolute container path; returns non-zero if we're not inside a
# wtm-managed (bare) repo.
_wt_container() {
  local common container
  common=$(git rev-parse --git-common-dir 2>/dev/null) || return 1
  # git may hand back a relative path (e.g. ".bare") when cwd is the container.
  case "$common" in
    /*) ;;
    *) common="$PWD/$common" ;;
  esac
  # -P (physical path): `git worktree list` reports symlink-resolved paths, and
  # we strip this prefix off them to get a worktree's relative name.
  container=$(cd "$(dirname "$common")" 2>/dev/null && pwd -P) || return 1
  # wtm requires the container to be a bare repository.
  [ "$(git -C "$container" config --get core.bare 2>/dev/null)" = "true" ] || return 1
  printf '%s\n' "$container"
}

# Registered worktree directories (absolute), excluding the bare entry.
_wt_paths() {
  local container="$1"
  git -C "$container" worktree list --porcelain 2>/dev/null \
    | awk '/^worktree /{print $2}' \
    | while IFS= read -r p; do
        [ "$p" = "$container" ] && continue
        [ "$p" = "$container/.bare" ] && continue
        printf '%s\n' "$p"
      done
}

# Print a worktree's lock reason (possibly empty) and return 0 if it's locked;
# return 1 if it isn't. supacode locks every worktree it adopts, writing a JSON
# reason like {"owner":"supacode",...} — git then refuses to remove the
# worktree at all (even `remove --force`, which is all wtm passes through), so
# `wt delete --force` unlocks first.
# NB: don't name a local "path" here — in zsh that's tied to $PATH.
_wt_lock_reason() {
  local container="$1" wtpath="$2"
  git -C "$container" worktree list --porcelain 2>/dev/null \
    | awk -v target="$wtpath" '
        $1 == "worktree" { cur = substr($0, 10) }
        cur == target && $1 == "locked" {
          found = 1
          if (length($0) > 7) reason = substr($0, 8)
          exit
        }
        END { if (found) { print reason; exit 0 } else exit 1 }
      '
}

# ---- wt list -----------------------------------------------------------------
# Column widths (the message column takes whatever's left over).
_WT_LIST_W_DIR=26
_WT_LIST_W_BRANCH=28
_WT_LIST_W_DATE=14
_WT_LIST_W_PR=13
_WT_LIST_W_MSG_MIN=20
# How many PRs to pull when matching branches. GitHub returns them newest-first,
# so a branch whose PR is older than this window shows a blank PR column.
_WT_LIST_PR_LIMIT=300

# One record per worktree from `git worktree list --porcelain`, as
# dir<US>branch<US>locked<US>sha. Skips the bare container entry.
_wt_list_records() {
  local container="$1"
  git -C "$container" worktree list --porcelain 2>/dev/null \
    | awk -v container="$container" '
        function emit(   dir) {
          if (wtpath == "" || wtpath == container || wtpath == container "/.bare") return
          # Plain prefix strip, not sub() — the container path is a literal, and
          # any "." in it would otherwise act as a regex wildcard.
          dir = (substr(wtpath, 1, length(container) + 1) == container "/") \
                  ? substr(wtpath, length(container) + 2) : wtpath
          printf "%s\037%s\037%s\037%s\n", dir, branch, locked, head
        }
        $1 == "worktree" { emit(); wtpath = substr($0, 10); branch = ""; locked = ""; head = "" }
        $1 == "HEAD"     { head = $2 }
        $1 == "branch"   { branch = substr($0, 8); sub("^refs/heads/", "", branch) }
        $1 == "detached" { branch = "(detached)" }
        $1 == "locked"   { locked = "1" }
        END { emit() }
      '
}

# Render the worktree table. Everything is joined inside a single awk pass over
# a tagged stream — C records (commit metadata), then P records (pull requests),
# then W records (the worktrees themselves) — so the whole listing costs one
# `git worktree list`, one `git log` and one `gh pr list` regardless of how many
# worktrees there are. Fields are \037-delimited because commit subjects can
# contain tabs.
_wt_list() {
  local container="$1" cols msgw dirw branchw avail
  cols="${COLUMNS:-0}"
  [ "$cols" -gt 0 ] 2>/dev/null || cols=$(tput cols 2>/dev/null) || cols=120
  [ "$cols" -gt 0 ] 2>/dev/null || cols=120

  # A row is: dir + 1 + lock(1) + 2 + branch + 2 + date + 2 + message + 2 + pr,
  # so the columns and gutters cost dir+branch+date+pr+message+10. Give the
  # message whatever's left, borrowing from the two widest columns rather than
  # letting the row run past the terminal and wrap.
  dirw=$_WT_LIST_W_DIR
  branchw=$_WT_LIST_W_BRANCH
  avail=$((cols - _WT_LIST_W_DATE - _WT_LIST_W_PR - 10))
  while [ $((avail - dirw - branchw)) -lt "$_WT_LIST_W_MSG_MIN" ]; do
    if [ "$branchw" -gt "$dirw" ] && [ "$branchw" -gt 12 ]; then
      branchw=$((branchw - 1))
    elif [ "$dirw" -gt 12 ]; then
      dirw=$((dirw - 1))
    else
      break   # already as tight as it goes; the message takes the hit
    fi
  done
  msgw=$((avail - dirw - branchw))
  [ "$msgw" -ge 1 ] || msgw=1

  local records
  records=$(_wt_list_records "$container")
  if [ -z "$records" ]; then
    printf 'wt: no worktrees\n' >&2
    return 0
  fi

  # Header. The unlabelled single-column gap after DIRECTORY is the lock flag.
  printf '\033[90m%-*s    %-*s  %-*s  %-*s  %s\033[0m\n' \
    "$dirw" "DIRECTORY" \
    "$branchw" "BRANCH" \
    "$_WT_LIST_W_DATE" "LAST COMMIT" \
    "$msgw" "MESSAGE" "PR"

  {
    # C: commit metadata for every checked-out HEAD, in one git call. The revs
    # go in on stdin rather than as arguments — zsh doesn't word-split an
    # unquoted expansion, so a "$shas" variable would arrive as a single rev.
    printf '%s\n' "$records" | awk -F'\037' '{ print $4 }' | sort -u \
      | git -C "$container" log --no-walk=unsorted --stdin \
          --format="C%x1f%H%x1f%cr%x1f%ct%x1f%s" 2>/dev/null

    # P: pull requests keyed by head branch. Best-effort — no gh, no auth or no
    # network just leaves the column blank.
    if [ "${WT_LIST_NO_PR:-0}" = 0 ] && command -v gh >/dev/null 2>&1; then
      ( cd "$container" && gh pr list --state all --limit "$_WT_LIST_PR_LIMIT" \
          --json number,state,isDraft,headRefName \
          --jq '.[] | ["P", .headRefName, (.number|tostring), .state, (.isDraft|tostring)] | join("\u001f")' 2>/dev/null )
    fi

    printf '%s\n' "$records" | awk '{ print "W\037" $0 }'
  } | awk -F'\037' \
        -v w_dir="$dirw" -v w_branch="$branchw" \
        -v w_date="$_WT_LIST_W_DATE" -v w_pr="$_WT_LIST_W_PR" -v w_msg="$msgw" '
      function pad(s, n,   d) { d = n - length(s); return d > 0 ? s sprintf("%*s", d, "") : s }
      function fit(s, n) { return pad(substr(s, 1, n), n) }
      BEGIN {
        e = sprintf("%c", 27)
        cyan = e "[36m"; yellow = e "[33m"; green = e "[32m"
        white = e "[37m"; gray = e "[90m"; purple = e "[38;5;99m"; reset = e "[0m"
        lock_icon = "\xef\x80\xa3"
      }
      $1 == "C" { rel[$2] = $3; ts[$2] = $4; subj[$2] = $5; next }
      $1 == "P" {
        # Newest first from gh, so keep the first PR seen for a branch unless a
        # later one is still open — an open PR is what you care about.
        if (!($2 in num) || ($4 == "OPEN" && state[$2] != "OPEN")) {
          num[$2] = $3; state[$2] = $4; draft[$2] = $5
        }
        next
      }
      {
        dir = $2; branch = $3; locked = $4; sha = $5
        lock_cell = locked == "1" ? yellow lock_icon reset : " "

        if (branch in num) {
          if (state[branch] == "OPEN" && draft[branch] == "true") { pc = gray;   pl = "#" num[branch] " draft" }
          else if (state[branch] == "OPEN")                       { pc = green;  pl = "#" num[branch] }
          else if (state[branch] == "MERGED")                     { pc = purple; pl = "#" num[branch] " merged" }
          else                                                     { pc = purple; pl = "#" num[branch] " closed" }
        } else { pc = gray; pl = "" }
        pr_cell = pc pad(substr(pl, 1, w_pr), w_pr) reset

        printf "%s\037%s%s%s %s  %s%s%s  %s%s%s  %s%s%s  %s\n",
          (sha in ts ? ts[sha] : 0),
          cyan, fit(dir, w_dir), reset, lock_cell,
          yellow, fit(branch, w_branch), reset,
          green, fit(rel[sha], w_date), reset,
          white, fit(subj[sha], w_msg), reset,
          pr_cell
      }
    ' | sort -t"$(printf '\037')" -k1,1nr | cut -d"$(printf '\037')" -f2-
}

# Resolve an existing worktree matching $2: exact relative path, or a unique
# trailing path segment. Prints its absolute path on success (rc 0). rc 1 = no
# match; rc 2 = ambiguous (candidates printed to stderr).
_wt_find() {
  local container="$1" name="$2" p leaf match count=0
  if [ -d "$container/$name" ]; then
    printf '%s\n' "$container/$name"
    return 0
  fi
  while IFS= read -r p; do
    leaf="${p##*/}"
    if [ "$leaf" = "$name" ]; then
      match="$p"
      count=$((count + 1))
    fi
  done < <(_wt_paths "$container")
  if [ "$count" -eq 1 ]; then
    printf '%s\n' "$match"
    return 0
  elif [ "$count" -gt 1 ]; then
    printf "wt: '%s' is ambiguous; use the full name:\n" "$name" >&2
    while IFS= read -r p; do
      leaf="${p##*/}"
      [ "$leaf" = "$name" ] && printf '  %s\n' "${p#$container/}" >&2
    done < <(_wt_paths "$container")
    return 2
  fi
  return 1
}

# Activate the current directory's Python venv and load its .env.
# wtm's post_create hook has already finished by this point (wtm runs it
# synchronously during create/checkout). Always returns 0.
_wt_activate() {
  [ -f .venv/bin/activate ] && source .venv/bin/activate
  if [ -f .env ]; then
    # Auto-export so the values are actually usable as environment variables.
    set -a
    source .env
    set +a
  fi
  return 0
}

# Open the kitty three-pane "Code" tab for the current worktree. No-op unless
# we're inside kitty and it's enabled. If a Code tab for this worktree already
# exists, focus it instead of stacking a duplicate. $1/$2, if set, are the model
# and permission-mode to pass through to the claude pane (new-coding-tab.sh
# defaults the permission mode to "auto" when none is forwarded).
_wt_open_code() {
  local model="$1" permmode="$2"
  [ "${WT_NO_CODE:-0}" = 0 ] || return 0
  [ -n "$KITTY_WINDOW_ID" ] || return 0
  command -v kitty >/dev/null 2>&1 || return 0
  local dotfiles="${DOTFILES_DIR:-$HOME/projects/dotfiles}"
  local proj="${PWD##*/}"
  # Prefix match (not exact): `wt pr` replaces the "Code:" label with
  # "PR #N:" (plus optional draft/merged note), so match either label.
  # Require the next char (if any) to be a space so "proj" doesn't also
  # match a differently-named tab like "proj2".
  if kitty @ focus-tab --match "title:^(Code|PR #[0-9]+[^:]*): ${proj}( |\$)" >/dev/null 2>&1; then
    return 0
  fi

  # If the tab we're running in has only this one window, it was almost
  # certainly opened just to type this `wt` command — remember it so we can
  # close it below, once the new Code tab exists, instead of leaving a bare
  # extra tab behind.
  local orig_tab_id="" orig_solo=0 info
  if command -v jq >/dev/null 2>&1; then
    info=$(kitty @ ls 2>/dev/null | jq -r --argjson wid "$KITTY_WINDOW_ID" '
      [.[].tabs[] | select(.windows[]?.id == $wid)][0]
      | if . == null then empty else "\(.id) \(.windows | length)" end
    ' 2>/dev/null) || info=""
    if [ -n "$info" ]; then
      orig_tab_id="${info%% *}"
      [ "${info##* }" = 1 ] && orig_solo=1
    fi
  fi

  local -a opts=()
  [ -n "$model" ] && opts+=(--model "$model")
  [ -n "$permmode" ] && opts+=(--permission-mode "$permmode")
  "$dotfiles/kitty/new-coding-tab.sh" "${opts[@]}"

  if [ "$orig_solo" = 1 ]; then
    kitty @ close-tab --match "id:$orig_tab_id" >/dev/null 2>&1 || true
  fi
}

# Navigate to (creating/checking out as needed) a worktree.
# Usage: _wt_go <name> [base] [--model <model>] [--permission-mode <mode>]
# (flags may appear anywhere)
_wt_go() {
  local name="" base="" model="" permmode="" container target reply found rc
  local base_explicit=0 cur_branch prompt_base offer_main_fallback
  while [ $# -gt 0 ]; do
    case "$1" in
      --model)
        if [ $# -lt 2 ]; then printf 'wt: --model requires a value\n' >&2; return 1; fi
        model="$2"; shift 2 ;;
      --model=*) model="${1#--model=}"; shift ;;
      --permission-mode)
        if [ $# -lt 2 ]; then printf 'wt: --permission-mode requires a value\n' >&2; return 1; fi
        permmode="$2"; shift 2 ;;
      --permission-mode=*) permmode="${1#--permission-mode=}"; shift ;;
      *)
        if [ -z "$name" ]; then name="$1"
        elif [ -z "$base" ]; then base="$1"
        fi
        shift ;;
    esac
  done
  [ -n "$base" ] && base_explicit=1
  [ -n "$base" ] || base="main"
  if [ -z "$name" ]; then printf 'wt: worktree name required\n' >&2; return 1; fi
  container=$(_wt_container) || { printf 'wt: not inside a wtm-managed repo\n' >&2; return 1; }

  # Already exists? Just go there.
  found=$(_wt_find "$container" "$name")
  rc=$?
  if [ "$rc" -eq 0 ]; then
    cd "$found" || return 1
    _wt_activate
    _wt_open_code "$model" "$permmode"
    return 0
  elif [ "$rc" -eq 2 ]; then
    return 1   # ambiguous — message already printed
  fi

  # Doesn't exist yet — check out an existing branch, or offer to create.
  target="$container/$name"
  if git -C "$container" show-ref --verify --quiet "refs/heads/$name"; then
    # Local branch exists but has no worktree — add one directly (wtm checkout
    # only handles remote branches).
    ( cd "$container" && git worktree add "$target" "$name" ) || return 1
  elif [ -n "$(git -C "$container" ls-remote --heads origin "$name" 2>/dev/null)" ]; then
    # Remote branch exists — let wtm check it out.
    ( cd "$container" && wtm checkout "$name" ) || return 1
  else
    # If the caller didn't pin a base explicitly and we're inside a worktree
    # (not the bare container root), default to branching off the current
    # worktree's branch instead of main — that's usually what's wanted when
    # starting a new worktree while already working on something. Declining
    # falls back to offering main.
    prompt_base="$base"
    offer_main_fallback=0
    if [ "$base_explicit" -eq 0 ] \
       && [ "$(git rev-parse --is-bare-repository 2>/dev/null)" = "false" ]; then
      cur_branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
      if [ -n "$cur_branch" ] && [ "$cur_branch" != "$base" ]; then
        prompt_base="$cur_branch"
        offer_main_fallback=1
      fi
    fi

    printf "Worktree '%s' does not exist. Create it from '%s'? [y/N] " "$name" "$prompt_base"
    read -r reply
    case "$reply" in
      [yY]*) base="$prompt_base" ;;
      *)
        if [ "$offer_main_fallback" -eq 1 ]; then
          printf "Create it from '%s' instead? [y/N] " "$base"
          read -r reply
          case "$reply" in
            [yY]*) ;;
            *) printf 'Aborted.\n'; return 1 ;;
          esac
        else
          printf 'Aborted.\n'
          return 1
        fi
        ;;
    esac
    ( cd "$container" && wtm create "$name" --from "$base" --no-shell ) || return 1
  fi

  if [ ! -d "$target" ]; then
    printf 'wt: expected worktree at %s but it was not created\n' "$target" >&2
    return 1
  fi

  cd "$target" || return 1
  _wt_activate
  _wt_open_code "$model" "$permmode"
}

# Check for a PR on the current branch and reflect it in the current kitty
# tab's title, replacing the "Code:" label with "PR #123:" (draft/merged
# noted too), e.g. "PR #123: myproject". Resets to the bare "Code: <project>"
# title when there's no open PR.
_wt_pr_title() {
  [ -n "$KITTY_WINDOW_ID" ] || { printf 'wt: not inside kitty\n' >&2; return 1; }
  command -v kitty >/dev/null 2>&1 || { printf 'wt: kitty not found\n' >&2; return 1; }
  command -v gh >/dev/null 2>&1 || { printf 'wt: gh (GitHub CLI) not found\n' >&2; return 1; }
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || { printf 'wt: not inside a git repo\n' >&2; return 1; }

  local proj label title pr_json number state draft
  proj="${PWD##*/}"

  pr_json=$(gh pr view --json number,state,isDraft -q '[.number,.state,.isDraft]|@tsv' 2>/dev/null)
  if [ -z "$pr_json" ]; then
    kitty @ set-tab-title "Code: $proj"
    printf 'wt: no PR found for this branch; title reset\n'
    return 0
  fi

  IFS=$'\t' read -r number state draft <<<"$pr_json"
  case "$state" in
    MERGED) label="PR #$number merged" ;;
    CLOSED) label="Code" ;;
    *)
      if [ "$draft" = "true" ]; then
        label="PR #$number draft"
      else
        label="PR #$number"
      fi
      ;;
  esac
  title="$label: $proj"
  kitty @ set-tab-title "$title"
  printf 'wt: tab title -> %s\n' "$title"
}

wt() {
  local sub="$1" container here rc
  case "$sub" in
    list|ls)
      shift
      container=$(_wt_container) \
        || { printf 'wt: not inside a wtm-managed repo\n' >&2; return 1; }
      _wt_list "$container"
      ;;
    delete|rm)
      shift
      container=$(_wt_container) \
        || { printf 'wt: not inside a wtm-managed repo\n' >&2; return 1; }

      # Pull out the worktree name and detect --force (which skips the
      # branch/path safety check, breaks any lock, and force-deletes).
      local force=0 name="" arg wtpath relpath branch frc reason
      for arg in "$@"; do
        case "$arg" in
          --force|-f) force=1 ;;
          -*) ;;
          *) [ -z "$name" ] && name="$arg" ;;
        esac
      done
      if [ -z "$name" ]; then printf 'wt: delete requires a worktree name\n' >&2; return 1; fi

      # Resolve the target worktree and the branch it currently has checked out.
      wtpath=$(_wt_find "$container" "$name"); frc=$?
      if [ "$frc" -ne 0 ]; then
        [ "$frc" -eq 1 ] && printf "wt: no worktree matching '%s'\n" "$name" >&2
        return 1   # frc 2 (ambiguous) already printed candidates
      fi
      relpath="${wtpath#$container/}"
      branch=$(git -C "$wtpath" symbolic-ref --quiet --short HEAD 2>/dev/null)

      # Safety: the checked-out branch must match the worktree's path, else we
      # might delete an unrelated branch. --force skips this check.
      if [ "$force" -eq 0 ] && [ "$branch" != "$relpath" ]; then
        printf "wt: worktree '%s' is on branch '%s', which does not match its path.\n" \
          "$relpath" "${branch:-<detached HEAD>}" >&2
        printf "    Refusing to delete. Re-run with --force to override.\n" >&2
        return 1
      fi

      # Locked worktrees (supacode locks the ones it manages) can't be removed
      # by wtm at all: it only ever passes a single --force to `git worktree
      # remove`, and git needs `-f -f` to break a lock. Unlock first instead.
      if reason=$(_wt_lock_reason "$container" "$wtpath"); then
        if [ "$force" -eq 0 ]; then
          printf "wt: worktree '%s' is locked%s.\n" "$relpath" \
            "${reason:+ (${reason})}" >&2
          printf "    Refusing to delete. Re-run with --force to break the lock.\n" >&2
          return 1
        fi
        git -C "$container" worktree unlock "$wtpath" || return 1
      fi

      here="$PWD"
      # Build wtm's args ourselves rather than forwarding "$@": wtm only
      # recognises the long --force (not -f), and its flag parser swallows the
      # next bare word as the flag's value, so --force has to come last.
      local -a wtm_args=("$relpath")
      [ "$force" -eq 1 ] && wtm_args+=(--force)
      ( cd "$container" && wtm delete "${wtm_args[@]}" )
      rc=$?
      # If we just deleted the worktree we were standing in, step out to the
      # container so we're not left in a phantom directory.
      [ -d "$here" ] || cd "$container"

      # wtm removes the worktree but leaves its branch behind — delete it too.
      # Use -D, not -d: wtm points the branch's upstream at a (usually absent)
      # origin/<name>, so -d would spuriously report it unmerged and refuse. The
      # branch/path match check above is what guards against deleting the wrong
      # branch (and unpushed commits, if any, go with it).
      if [ "$rc" -eq 0 ] && [ -n "$branch" ]; then
        git -C "$container" branch -D "$branch"
      fi
      return $rc
      ;;
    pr)
      shift
      _wt_pr_title "$@"
      ;;
    ""|-h|--help|help)
      cat <<'EOF'
wt — git worktree helper (wraps wtm)

  wt <name> [base] [--model <m>] [--permission-mode <p>]
                     Go to worktree <name>; create or check it out if missing.
                     New worktrees are created from <base> if given, else
                     "main" — unless run from inside a worktree, in which
                     case that worktree's branch is offered first (declining
                     falls back to offering "main"). Activates .venv/.env and
                     opens the kitty Code tab. --model <m> and
                     --permission-mode <p> pass through to the claude pane;
                     permission-mode defaults to "auto".
  wt list            Table of every worktree: directory, lock flag, branch,
                     last commit date + subject, and the branch's PR (green
                     open, gray draft, purple merged/closed), newest first.
  wt delete <name> [-f|--force]
                     Delete a worktree and its matching local branch.
                     Refuses on a branch/path mismatch, or if the worktree
                     is locked; -f/--force skips the check, unlocks, and
                     force-deletes.
  wt pr              Check gh for a PR on the current branch and update the
                     current kitty tab's title to reflect it, replacing the
                     "Code:" label (e.g. "PR #123: myproject"), noting
                     draft/merged state. Resets to the bare title if there's
                     no PR.
EOF
      ;;
    *)
      _wt_go "$@"
      ;;
  esac
}

# Auto-activate .venv/.env when an interactive shell starts inside a worktree.
# This is what gives every code-view pane (and any shell opened in a worktree)
# the venv + env, even though the shell rc rebuilds PATH on startup.
wt_autoactivate() {
  case $- in *i*) ;; *) return 0 ;; esac
  [ "${WT_AUTO_ACTIVATE:-1}" = 1 ] || return 0
  _wt_container >/dev/null 2>&1 || return 0                       # in a wtm repo?
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0 # a worktree, not the bare root
  _wt_activate
}

# ---- completion --------------------------------------------------------------
if [ -n "$BASH_VERSION" ]; then
  _wt_complete_bash() {
    local cur="${COMP_WORDS[COMP_CWORD]}" container names
    [ "$COMP_CWORD" -eq 1 ] || return 0
    names="list delete pr"
    container=$(_wt_container 2>/dev/null)
    if [ -n "$container" ]; then
      names="$names $(_wt_paths "$container" | sed "s#^$container/##")"
    fi
    COMPREPLY=( $(compgen -W "$names" -- "$cur") )
  }
  complete -F _wt_complete_bash wt
elif [ -n "$ZSH_VERSION" ]; then
  # Wrapped in eval so bash never parses the zsh-only syntax below.
  eval '
    _wt() {
      if (( CURRENT == 2 )); then
        local container; container=$(_wt_container 2>/dev/null)
        local -a names
        if [[ -n "$container" ]]; then
          names=(${(f)"$(_wt_paths "$container" | sed "s#^$container/##")"})
        fi
        _alternative "commands:command:(list delete pr)" "worktrees:worktree:(${names})"
      fi
    }
    (( $+functions[compdef] )) && compdef _wt wt
  '
fi
