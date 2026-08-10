#!/bin/sh
# Kicks off a background cache refresh if one isn't already running, then
# immediately prints the CURRENT cache unchanged, so fzf's reload() swaps in
# identical content and the visible list is never disrupted while the real
# fetch (which can take 10-20s) runs out of view. The new data only becomes
# visible on a later reload (e.g. the next ctrl-r or ctrl-f press) once the
# background job has atomically replaced the cache file.
# Usage: prreview-refresh-async.sh <cache-dir> <w-updated> <w-repo> <w-status> <w-submitter> <w-title>
cache_dir="$1"
shift
prreview_dir="$HOME/projects/dotfiles/cli/prreview"
lock_dir="$cache_dir/refresh.lock"
cache_file="$cache_dir/list.tsv"

# Clear a stale lock (e.g. left behind by a killed terminal) rather than
# blocking refreshes forever.
if [ -d "$lock_dir" ]; then
  lock_mtime=$(stat -f %m "$lock_dir" 2>/dev/null || stat -c %Y "$lock_dir" 2>/dev/null || echo 0)
  now=$(date +%s)
  if [ $((now - lock_mtime)) -gt 120 ]; then
    rmdir "$lock_dir" 2>/dev/null
  fi
fi

if mkdir "$lock_dir" 2>/dev/null; then
  (
    trap 'rmdir "$lock_dir" 2>/dev/null' EXIT
    tmp_file=$(mktemp "$cache_dir/list.tsv.XXXXXX")
    if sh "$prreview_dir/prreview-fetch.sh" "$@" > "$tmp_file"; then
      mv "$tmp_file" "$cache_file"
      date '+%Y-%m-%d %H:%M:%S' > "$cache_dir/last_updated"
    else
      rm -f "$tmp_file"
    fi
  ) >/dev/null 2>&1 &
fi

cat "$cache_file" 2>/dev/null
