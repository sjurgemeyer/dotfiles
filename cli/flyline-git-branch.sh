#!/usr/bin/env bash
# Used as a flyline custom prompt widget (see cli/flyline-settings.sh) to show
# the current git branch in the PS1_FINAL transient prompt. Prints nothing
# when not inside a git repo / on a branch, so the prompt just shows the dir.
# Styled to match the dimmed final prompt (see cli/flyline-settings.sh): dark-gray
# background (256-color 236) + faint yellow, so the branch blends into the rest of
# the transient line. PS1_FINAL re-establishes the background after this widget.
branch=$(git branch --show-current 2>/dev/null)
if [ -n "$branch" ]; then
  printf '\033[48;5;236;2;33m %s\033[0m' "$branch"
fi
exit 0
