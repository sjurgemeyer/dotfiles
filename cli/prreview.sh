
function prreview  {

header=$(printf '\033[1;36m%-35s\033[0m  \033[1;37m%-60s\033[0m  \033[1;33m%-18s\033[0m  \033[1;32m%-16s\033[0m  \033[1;35m%-12s\033[0m\n\033[2menter: open in browser  ·  ctrl-f: cycle filter [All]\033[0m' \
  "REPO" "PR TITLE" "SUBMITTER" "UPDATED" "APPROVED")

local filter_state
filter_state=$(mktemp)
echo 0 > "$filter_state"

gh api --paginate user/subscriptions --jq '.[].full_name' | \
  while read -r repo; do
    gh pr list --repo "$repo" --state=open \
      --json title,updatedAt,author,url,reviewDecision \
      --jq '.[] | ["'"$repo"'", .title, .author.login, .updatedAt, .reviewDecision, .url] | @tsv'
  done | sort -t$'\t' -k4 -r | \
  awk -F'\t' 'BEGIN {
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
    printf "%s%-35s%s  %s%-60s%s  %s%-18s%s  %s%-16s%s  %s%-12s%s\t%s\n",
      cyan,   substr($1,1,35), reset,
      white,  substr($2,1,60), reset,
      yellow, substr($3,1,18), reset,
      green,  substr($4,1,16), reset,
      acolor, atext, reset,
      $6
  }' | \
  FZF_DEFAULT_OPTS= fzf --ansi --exact \
      --delimiter=$'\t' \
      --with-nth=1 \
      --header="$header" \
      --bind 'enter:become(open {2})' \
      --bind "ctrl-f:transform-query(sh $HOME/projects/dotfiles/cli/prreview-filter-cycle.sh $filter_state)+transform-header(sh $HOME/projects/dotfiles/cli/prreview-filter-header.sh $filter_state)"

rm -f "$filter_state"
}
