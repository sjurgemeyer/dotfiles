function prreview  {

local W_UPDATED=16 W_REPO=35 W_STATUS=10 W_SUBMITTER=18 W_TITLE=60

local cache_dir="$HOME/.cache/prreview"
mkdir -p "$cache_dir"
local cache_file="$cache_dir/list.tsv"
local last_filter_file="$cache_dir/last_filter"

local filter_state
filter_state=$(mktemp)
local initial_idx
initial_idx=$(cat "$last_filter_file" 2>/dev/null)
case "$initial_idx" in
  1|2|3|4|5|6) ;;
  *) initial_idx=0 ;;
esac
echo "$initial_idx" > "$filter_state"

local initial_query
initial_query=$(sh "$HOME/projects/dotfiles/cli/prreview/prreview-filter-query.sh" "$initial_idx")
local header
header=$(sh "$HOME/projects/dotfiles/cli/prreview/prreview-filter-header.sh" "$filter_state" "$cache_dir" "$W_UPDATED" "$W_REPO" "$W_STATUS" "$W_SUBMITTER" "$W_TITLE")

if [[ -s "$cache_file" ]]; then
  cat "$cache_file"
  sh "$HOME/projects/dotfiles/cli/prreview/prreview-maybe-refresh.sh" "$cache_dir" "$W_UPDATED" "$W_REPO" "$W_STATUS" "$W_SUBMITTER" "$W_TITLE" > /dev/null 2>&1
else
  sh "$HOME/projects/dotfiles/cli/prreview/prreview-refresh.sh" "$cache_dir" "$W_UPDATED" "$W_REPO" "$W_STATUS" "$W_SUBMITTER" "$W_TITLE"
fi | \
  FZF_DEFAULT_OPTS= fzf --ansi --exact --no-sort \
      --delimiter=$'\t' \
      --with-nth=1 \
      --header="$header" \
      --query="$initial_query" \
      --info-command="sh $HOME/projects/dotfiles/cli/prreview/prreview-info.sh $cache_dir" \
      --bind 'enter:become(open {2})' \
      --bind "ctrl-r:reload(sh $HOME/projects/dotfiles/cli/prreview/prreview-refresh-async.sh $cache_dir $W_UPDATED $W_REPO $W_STATUS $W_SUBMITTER $W_TITLE)+transform-header(sh $HOME/projects/dotfiles/cli/prreview/prreview-filter-header.sh $filter_state $cache_dir $W_UPDATED $W_REPO $W_STATUS $W_SUBMITTER $W_TITLE)" \
      --bind "ctrl-f:transform-query(sh $HOME/projects/dotfiles/cli/prreview/prreview-filter-cycle.sh $filter_state)+transform-header(sh $HOME/projects/dotfiles/cli/prreview/prreview-filter-header.sh $filter_state $cache_dir $W_UPDATED $W_REPO $W_STATUS $W_SUBMITTER $W_TITLE)"

cp "$filter_state" "$last_filter_file" 2>/dev/null
rm -f "$filter_state"

}
