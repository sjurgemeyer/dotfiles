#!/bin/sh
# Triggers a background refresh if the cache is missing or older than 5
# minutes. Safe to call unconditionally on every launch: the refresh itself
# is a no-op if one is already running (see prreview-refresh-async.sh), and
# this script always returns immediately regardless of what it decides.
# Usage: prreview-maybe-refresh.sh <cache-dir> <w-updated> <w-repo> <w-status> <w-submitter> <w-title>
cache_dir="$1"
prreview_dir="$HOME/projects/dotfiles/cli/prreview"
max_age=300

last_updated_str=$(cat "$cache_dir/last_updated" 2>/dev/null)
last_updated_epoch=0
if [ -n "$last_updated_str" ]; then
  last_updated_epoch=$(date -j -f '%Y-%m-%d %H:%M:%S' "$last_updated_str" +%s 2>/dev/null)
  [ -n "$last_updated_epoch" ] || last_updated_epoch=$(date -d "$last_updated_str" +%s 2>/dev/null)
  [ -n "$last_updated_epoch" ] || last_updated_epoch=0
fi

now_epoch=$(date +%s)
if [ $(( now_epoch - last_updated_epoch )) -gt "$max_age" ]; then
  sh "$prreview_dir/prreview-refresh-async.sh" "$@" >/dev/null 2>&1 &
fi
