#!/bin/sh
# Prints the prreview fzf header reflecting the currently active filter.
# Usage: prreview-filter-header.sh <state-file>
state_file="$1"
idx=$(cat "$state_file" 2>/dev/null || echo 0)
case "$idx" in
  1) name="My PRs" ;;
  2) name="My Approved PRs" ;;
  3) name="All Approved PRs" ;;
  *) name="All" ;;
esac
printf '\033[1;36m%-35s\033[0m  \033[1;37m%-60s\033[0m  \033[1;33m%-18s\033[0m  \033[1;32m%-16s\033[0m  \033[1;35m%-12s\033[0m\n\033[2menter: open in browser  ·  ctrl-f: cycle filter [%s]\033[0m' \
  "REPO" "PR TITLE" "SUBMITTER" "UPDATED" "APPROVED" "$name"
