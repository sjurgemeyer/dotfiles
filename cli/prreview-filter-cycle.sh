#!/bin/sh
# Advances the prreview fzf filter state and prints the resulting fzf query.
# Usage: prreview-filter-cycle.sh <state-file>
state_file="$1"
idx=$(cat "$state_file" 2>/dev/null || echo 0)
idx=$(( (idx + 1) % 4 ))
echo "$idx" > "$state_file"
case "$idx" in
  1) printf '%s' "sjurgemeyer_rba" ;;
  2) printf '%s' "sjurgemeyer_rba Approved" ;;
  3) printf '%s' "Approved" ;;
  *) printf '%s' "" ;;
esac
