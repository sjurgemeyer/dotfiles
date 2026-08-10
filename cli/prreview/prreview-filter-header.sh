#!/bin/sh
# Prints the prreview fzf header reflecting the currently active filter.
# Usage: prreview-filter-header.sh <state-file> <cache-dir> <w-updated> <w-repo> <w-status> <w-submitter> <w-title>
state_file="$1"
cache_dir="$2"
w_updated="${3:-16}"
w_repo="${4:-35}"
w_status="${5:-8}"
w_submitter="${6:-18}"
w_title="${7:-60}"
idx=$(cat "$state_file" 2>/dev/null || echo 0)
case "$idx" in
  1) name="My PRs" ;;
  2) name="My Approved PRs" ;;
  3) name="All Approved PRs" ;;
  4) name="Others' PRs" ;;
  5) name="Drafts" ;;
  6) name="My Drafts" ;;
  *) name="All" ;;
esac
last_updated=$(cat "$cache_dir/last_updated" 2>/dev/null)
[ -n "$last_updated" ] || last_updated="never"
printf '\033[1;32m%-*s\033[0m  \033[1;36m%-*s\033[0m  \033[1;33m%-*s\033[0m  \033[33m%-*s\033[0m  \033[38;5;30m%-*s\033[0m\n\033[1;34m[%s]\033[0m enter: open ctrl-f: cycle ctrl-r: refresh \033[1;33m(Updated %s)\033[0m' \
  "$w_updated" "UPDATED" "$w_repo" "REPO" "$w_status" "STATUS" "$w_submitter" "SUBMITTER" "$w_title" "DESCRIPTION" "$name" "$last_updated"
