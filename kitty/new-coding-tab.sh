#!/usr/bin/env bash
# Create a new "Coding" tab with the standard three-window layout:
#   +------------------+-----------+
#   |       nvim       |  claude   |
#   +------------------+-----------+
#   |            terminal          |
#   +------------------------------+
#
# We capture nvim's window id and use --next-to to explicitly split it,
# which is more reliable than juggling focus between launches.

set -euo pipefail

# Optional --model / --permission-mode are passed through to the claude pane.
# --permission-mode defaults to "auto".
MODEL=""
PERM_MODE="auto"
while [ $# -gt 0 ]; do
  case "$1" in
    --model)
      if [ $# -lt 2 ]; then echo "new-coding-tab: --model requires a value" >&2; exit 1; fi
      MODEL="$2"; shift 2 ;;
    --model=*) MODEL="${1#--model=}"; shift ;;
    --permission-mode)
      if [ $# -lt 2 ]; then echo "new-coding-tab: --permission-mode requires a value" >&2; exit 1; fi
      PERM_MODE="$2"; shift 2 ;;
    --permission-mode=*) PERM_MODE="${1#--permission-mode=}"; shift ;;
    *) echo "new-coding-tab: unknown argument: $1" >&2; exit 1 ;;
  esac
done

# Assemble the claude command: always set the permission mode, add --model only
# when one was given.
CLAUDE_CMD=(claude --permission-mode "$PERM_MODE")
[ -n "$MODEL" ] && CLAUDE_CMD+=(--model "$MODEL")

# Capture the originating cwd before we create a new tab. Once the new
# tab becomes active, --cwd=current would resolve to the new tab's
# shell cwd instead of the window we launched from. Requires the
# keybinding to invoke this script with "launch --type=background
# --cwd=current ..." so $PWD points at the source window's cwd.
PROJECT_CWD="$PWD"
PROJECT_NAME="$(basename "$PROJECT_CWD")"

# New tab, full-width nvim window. Capture its window id.
# --copy-env carries the caller's environment (e.g. an activated .venv and
# variables sourced from .env by `wt`) into every pane.
NVIM_ID=$(kitty @ launch \
    --type=tab \
    --tab-title="Code: $PROJECT_NAME" \
    --cwd="$PROJECT_CWD" \
    --copy-env \
    nvim)

# Switch this tab to the splits layout
kitty @ goto-layout --match="id:$NVIM_ID" splits

# Horizontal split of nvim: adds terminal row underneath.
# --bias=20 makes the new (bottom) window take 20% of the vertical
# space; nvim keeps the other 80%. This scales with the display size
# instead of the fixed-cell-count resize-window approach.
TERM_ID=$(kitty @ launch \
 --location=hsplit \
 --bias=10 \
 --copy-env \
 --cwd="$PROJECT_CWD")

kitty @ focus-window --match="id:$NVIM_ID" 
# Vertical split of nvim: adds claude to the right
CLAUDE_ID=$(kitty @ launch --location=vsplit \
    --cwd="$PROJECT_CWD" \
    --copy-env \
    --env=PATH=/opt/homebrew/bin:/usr/bin:/bin:$HOME/.local/bin \
    "${CLAUDE_CMD[@]}")

