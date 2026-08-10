#!/bin/sh
# Prints the fzf query string for a given prreview filter index (0-6).
# Usage: prreview-filter-query.sh <idx>
. "$HOME/projects/dotfiles/cli/prreview/prreview-config.sh"
idx="${1:-0}"
approved_icon=$(printf '\xef\x81\x9d')
draft_icon=$(printf '\xef\x81\x80')
case "$idx" in
  1) printf '%s' "$PRREVIEW_GITHUB_USER !$draft_icon" ;;
  2) printf '%s' "$PRREVIEW_GITHUB_USER $approved_icon !$draft_icon" ;;
  3) printf '%s' "$approved_icon !$draft_icon" ;;
  4) printf '%s' "!$PRREVIEW_GITHUB_USER !$draft_icon" ;;
  5) printf '%s' "$draft_icon" ;;
  6) printf '%s' "$PRREVIEW_GITHUB_USER $draft_icon" ;;
  *) printf '%s' "!$draft_icon" ;;
esac
