#!/bin/sh
# Prints the fzf info line, prefixed with an animated spinner while a
# background cache refresh is in progress. Used via fzf's --info-command,
# which re-runs this on every redraw, giving a live indicator without
# requiring a keypress.
# Usage: prreview-info.sh <cache-dir>
cache_dir="$1"

if [ -d "$cache_dir/refresh.lock" ]; then
  case $(( $(date +%s) % 10 )) in
    0) printf '\033[33m\xe2\xa0\x8b Refreshing\033[0m  %s' "$FZF_INFO" ;;
    1) printf '\033[33m\xe2\xa0\x99 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    2) printf '\033[33m\xe2\xa0\xb9 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    3) printf '\033[33m\xe2\xa0\xb8 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    4) printf '\033[33m\xe2\xa0\xbc Refreshing\033[0m  %s' "$FZF_INFO" ;;
    5) printf '\033[33m\xe2\xa0\xb4 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    6) printf '\033[33m\xe2\xa0\xa6 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    7) printf '\033[33m\xe2\xa0\xa7 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    8) printf '\033[33m\xe2\xa0\x87 Refreshing\033[0m  %s' "$FZF_INFO" ;;
    9) printf '\033[33m\xe2\xa0\x8f Refreshing\033[0m  %s' "$FZF_INFO" ;;
  esac
else
  printf '%s' "$FZF_INFO"
fi
