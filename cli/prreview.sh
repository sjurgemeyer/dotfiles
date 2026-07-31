
function prreview  {

local W_UPDATED=16 W_REPO=35 W_APPROVED=12 W_SUBMITTER=18 W_TITLE=60

header=$(printf '\033[1;32m%-*s\033[0m  \033[1;36m%-*s\033[0m  \033[1;35m%-*s\033[0m  \033[1;33m%-*s\033[0m  \033[1;37m%-*s\033[0m\n\033[2menter: open in browser  ·  ctrl-f: cycle filter [All]\033[0m' \
  "$W_UPDATED" "UPDATED" "$W_REPO" "REPO" "$W_APPROVED" "APPROVED" "$W_SUBMITTER" "SUBMITTER" "$W_TITLE" "PR TITLE")

local filter_state
filter_state=$(mktemp)
echo 0 > "$filter_state"

gh api --paginate user/subscriptions --jq '.[].full_name' | \
  while read -r repo; do
    short_repo="${repo#*/}"
    gh pr list --repo "$repo" --state=open \
      --json title,updatedAt,author,url,reviewDecision \
      --jq '.[] | ["'"$short_repo"'", .title, .author.login, .updatedAt, .reviewDecision, .url] | @tsv'
  done | sort -t$'\t' -k4 -r | \
  awk -F'\t' -v w_upd="$W_UPDATED" -v w_repo="$W_REPO" -v w_appr="$W_APPROVED" -v w_sub="$W_SUBMITTER" -v w_title="$W_TITLE" 'BEGIN {
    e = sprintf("%c", 27);
    cyan   = e "[36m";
    white  = e "[37m";
    yellow = e "[33m";
    green  = e "[32m";
    red    = e "[31m";
    gray   = e "[90m";
    reset  = e "[0m";
  }
  {
    gsub("T"," ",$4); gsub("Z","",$4);
    if ($5 == "APPROVED")               { acolor = green; atext = "Approved" }
    else if ($5 == "CHANGES_REQUESTED") { acolor = red; atext = "Changes Req" }
    else if ($5 == "REVIEW_REQUIRED")   { acolor = yellow; atext = "Review Req" }
    else                                 { acolor = gray; atext = "-" }
    printf "%s%-*s%s  %s%-*s%s  %s%-*s%s  %s%-*s%s  %s%-*s%s\t%s\n",
      green,  w_upd,   substr($4,1,w_upd),   reset,
      cyan,   w_repo,  substr($1,1,w_repo),  reset,
      acolor, w_appr,  atext,                reset,
      yellow, w_sub,   substr($3,1,w_sub),   reset,
      white,  w_title, substr($2,1,w_title), reset,
      $6
  }' | \
  FZF_DEFAULT_OPTS= fzf --ansi --exact \
      --delimiter=$'\t' \
      --with-nth=1 \
      --header="$header" \
      --bind 'enter:become(open {2})' \
      --bind "ctrl-f:transform-query(sh $HOME/projects/dotfiles/cli/prreview-filter-cycle.sh $filter_state)+transform-header(sh $HOME/projects/dotfiles/cli/prreview-filter-header.sh $filter_state $W_UPDATED $W_REPO $W_APPROVED $W_SUBMITTER $W_TITLE)"

rm -f "$filter_state"
}
