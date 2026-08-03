#!/bin/sh
# Fetches the PR list, writes it to the cache file, and stamps the update time.
# Usage: prreview-refresh.sh <cache-dir> <w-updated> <w-repo> <w-status> <w-submitter> <w-title>
cache_dir="$1"
shift
sh "$HOME/projects/dotfiles/cli/prreview/prreview-fetch.sh" "$@" | tee "$cache_dir/list.tsv"
date '+%Y-%m-%d %H:%M:%S' > "$cache_dir/last_updated"
