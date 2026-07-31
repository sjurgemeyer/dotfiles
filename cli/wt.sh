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
#                      <base> defaults to "main". After landing, activates the
#                      worktree's .venv and .env, and (inside kitty) opens the
#                      three-pane "Code" tab (nvim / claude / terminal).
#                      --model <m> and --permission-mode <p> are passed through
#                      to the claude pane; permission-mode defaults to "auto".
#   wt list            List worktrees (wtm list).
#   wt delete <name>   Delete a worktree and the matching local branch. Refuses
#                      if the worktree's checked-out branch doesn't match its
#                      path; --force skips that check and force-deletes.
#   wt pr              Check gh for a PR on the current branch and update the
#                      current kitty tab's title to reflect it.
#
# Knobs:  WT_NO_CODE=1        don't open the kitty Code tab
#         WT_AUTO_ACTIVATE=0  don't auto-activate .venv/.env in new worktree shells

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
  container=$(cd "$(dirname "$common")" 2>/dev/null && pwd) || return 1
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
  local -a opts=()
  [ -n "$model" ] && opts+=(--model "$model")
  [ -n "$permmode" ] && opts+=(--permission-mode "$permmode")
  "$dotfiles/kitty/new-coding-tab.sh" "${opts[@]}"
}

# Navigate to (creating/checking out as needed) a worktree.
# Usage: _wt_go <name> [base] [--model <model>] [--permission-mode <mode>]
# (flags may appear anywhere)
_wt_go() {
  local name="" base="" model="" permmode="" container target reply found rc
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
    printf "Worktree '%s' does not exist. Create it from '%s'? [y/N] " "$name" "$base"
    read -r reply
    case "$reply" in
      [yY]*) ;;
      *) printf 'Aborted.\n'; return 1 ;;
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
      ( cd "$container" && wtm list "$@" )
      ;;
    delete|rm)
      shift
      container=$(_wt_container) \
        || { printf 'wt: not inside a wtm-managed repo\n' >&2; return 1; }

      # Pull out the worktree name and detect --force (which skips the
      # branch/path safety check and force-deletes the branch).
      local force=0 name="" arg wtpath relpath branch frc
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

      here="$PWD"
      ( cd "$container" && wtm delete "$@" )
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
                     New worktrees are created from <base> (default: main).
                     Activates .venv/.env and opens the kitty Code tab.
                     --model <m> and --permission-mode <p> pass through to the
                     claude pane; permission-mode defaults to "auto".
  wt list            List worktrees.
  wt delete <name>   Delete a worktree and its matching local branch.
                     Refuses on a branch/path mismatch; --force skips the
                     check and force-deletes.
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
