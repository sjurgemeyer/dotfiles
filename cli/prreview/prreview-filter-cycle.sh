#!/bin/sh
# Advances the prreview fzf filter state and prints the resulting fzf query.
# Usage: prreview-filter-cycle.sh <state-file>
state_file="$1"
idx=$(cat "$state_file" 2>/dev/null || echo 0)
idx=$(( (idx + 1) % 5 ))
echo "$idx" > "$state_file"
sh "$HOME/projects/dotfiles/cli/prreview/prreview-filter-query.sh" "$idx"
