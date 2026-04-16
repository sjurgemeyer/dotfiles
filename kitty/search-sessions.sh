#!/usr/bin/env bash

# List kitty session files from the sessions directory using fzf,
# then activate the selected session via kitty's goto_session action.

set -euo pipefail

kitty_bin="/Applications/kitty.app/Contents/MacOS/kitty"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
sessions_dir="${script_dir}/sessions"

# Requirements
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed. Install with: brew install fzf"
  exit 1
fi

if [[ ! -x "$kitty_bin" ]]; then
  echo "kitty binary not found at: $kitty_bin"
  exit 1
fi

sock="$(ls /tmp/kitty-* 2>/dev/null | head -n1 || true)"
if [[ -z "${sock:-}" ]]; then
  echo "No kitty sockets found in /tmp (kitty not running, or remote control not enabled)."
  exit 1
fi

if [[ ! -d "$sessions_dir" ]]; then
  echo "Sessions directory not found: $sessions_dir"
  exit 1
fi

# Build list of session names from .kitty-session files
session_files=("$sessions_dir"/*.kitty-session)
if [[ ${#session_files[@]} -eq 0 || ! -e "${session_files[0]}" ]]; then
  echo "No .kitty-session files found in $sessions_dir"
  exit 1
fi

# Display session names (filename without extension) and let user pick
selected="$(
  for f in "${session_files[@]}"; do
    basename "$f" .kitty-session
  done | fzf --reverse --prompt="Select session > "
)" || exit 0

if [[ -z "$selected" ]]; then
  exit 0
fi

session_file="${sessions_dir}/${selected}.kitty-session"
"$kitty_bin" @ --to "unix:${sock}" action goto_session "$session_file"
