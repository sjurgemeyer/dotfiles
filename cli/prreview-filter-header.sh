#!/bin/sh
# Prints the prreview fzf header reflecting the currently active filter.
# Usage: prreview-filter-header.sh <state-file> <w-updated> <w-repo> <w-approved> <w-submitter> <w-title>
state_file="$1"
w_updated="${2:-16}"
w_repo="${3:-35}"
w_approved="${4:-12}"
w_submitter="${5:-18}"
w_title="${6:-60}"
idx=$(cat "$state_file" 2>/dev/null || echo 0)
case "$idx" in
  1) name="My PRs" ;;
  2) name="My Approved PRs" ;;
  3) name="All Approved PRs" ;;
  *) name="All" ;;
esac
printf '\033[1;32m%-*s\033[0m  \033[1;36m%-*s\033[0m  \033[1;35m%-*s\033[0m  \033[1;33m%-*s\033[0m  \033[1;37m%-*s\033[0m\n\033[2menter: open in browser  ·  ctrl-f: cycle filter [%s]\033[0m' \
  "$w_updated" "UPDATED" "$w_repo" "REPO" "$w_approved" "APPROVED" "$w_submitter" "SUBMITTER" "$w_title" "PR TITLE" "$name"
