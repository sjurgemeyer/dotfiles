#!/bin/sh
# Prints the fzf query string for a given prreview filter index (0-4).
# Usage: prreview-filter-query.sh <idx>
. "$HOME/projects/dotfiles/cli/prreview/prreview-config.sh"
idx="${1:-0}"
approved_icon=$(printf '\xef\x81\x9d')
case "$idx" in
  1) printf '%s' "$PRREVIEW_GITHUB_USER" ;;
  2) printf '%s' "$PRREVIEW_GITHUB_USER $approved_icon" ;;
  3) printf '%s' "$approved_icon" ;;
  4) printf '%s' "!$PRREVIEW_GITHUB_USER" ;;
  *) printf '%s' "" ;;
esac
