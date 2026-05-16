
function _prreview_open {
  local url="$1"
  if [[ ! "$url" =~ ^https://github.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
    print -u2 "Invalid PR URL: $url"
    return 1
  fi
  local owner="${match[1]}"
  local repo="${match[2]}"
  local pr_num="${match[3]}"

  local local_dir="" candidate remote
  while IFS= read -r candidate; do
    remote=$(git -C "$candidate" remote -v 2>/dev/null | awk '{print $2}' | head -n1)
    if [[ "$remote" == *"$owner/$repo"* ]]; then
      local_dir="$candidate"
      break
    fi
  done < <(fd -t d -H "^${repo}$" "$HOME/projects" 2>/dev/null)

  if [[ -z "$local_dir" ]]; then
    print -u2 "No local clone of $owner/$repo found under ~/projects"
    sleep 2
    return 1
  fi

  cd "$local_dir" || return 1
  nvim -c "Octo pr edit $pr_num $owner/$repo" -c "Octo review start"
}

function prreview  {

header=$(printf '\033[1;36m%-35s\033[0m  \033[1;37m%-60s\033[0m  \033[1;33m%-18s\033[0m  \033[1;32m%-16s\033[0m\n\033[2menter: open in browser  ·  ctrl-d: open Octo review in nvim\033[0m' \
  "REPO" "PR TITLE" "SUBMITTER" "UPDATED")

gh api --paginate user/subscriptions --jq '.[].full_name' | \
  while read -r repo; do
    gh pr list --repo "$repo" --state=open \
      --json title,updatedAt,author,url \
      --jq '.[] | ["'"$repo"'", .title, .author.login, .updatedAt, .url] | @tsv'
  done | sort -t$'\t' -k4 -r | \
  awk -F'\t' 'BEGIN {
    e = sprintf("%c", 27);
    cyan   = e "[36m";
    white  = e "[37m";
    yellow = e "[33m";
    green  = e "[32m";
    reset  = e "[0m";
  }
  {
    gsub("T"," ",$4); gsub("Z","",$4);
    printf "%s%-35s%s  %s%-60s%s  %s%-18s%s  %s%-16s%s\t%s\n",
      cyan,   substr($1,1,35), reset,
      white,  substr($2,1,60), reset,
      yellow, substr($3,1,18), reset,
      green,  substr($4,1,16), reset,
      $5
  }' | \
  FZF_DEFAULT_OPTS= fzf --ansi \
      --delimiter=$'\t' \
      --with-nth=1 \
      --header="$header" \
      --bind 'enter:become(open {2})' \
      --bind "ctrl-d:become(source $HOME/projects/dotfiles/cli/prreview.sh && _prreview_open {2})"
}

