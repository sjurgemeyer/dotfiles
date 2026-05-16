#!/usr/bin/env bash
# Claude Code Status Line — Context Window Monitor
# Reads JSON from stdin (injected by Claude Code's statusLine hook)
# and outputs a color-coded context bar to stdout.
#
# SETUP:
#   1. Save this file to ~/.claude/statusline.sh
#   2. Make it executable:  chmod +x ~/.claude/statusline.sh
#   3. Add to ~/.claude/settings.json:
#        { "statusLine": "~/.claude/statusline.sh" }
#   4. Restart Claude Code and accept the trust prompt.
#
# TEST without Claude Code running:
#   echo '{"model":{"display_name":"Sonnet"},"context_window":{"used_percentage":42,"total_input_tokens":84000,"context_window_size":200000}}' | ./statusline.sh

set -euo pipefail

# ── Read JSON from stdin ─────────────────────────────────────────────────────
INPUT="$(cat)"

# ── Parse fields via jq ──────────────────────────────────────────────────────
PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // empty')
PCT="${PCT:-"0"}"

# ── Round percentage to integer ───────────────────────────────────────────────
PCT_INT=$(printf "%.0f" "$PCT" 2>/dev/null || echo "0")

# ── ANSI colour based on usage ────────────────────────────────────────────────
if   [ "$PCT_INT" -ge 90 ]; then COLOR="\033[1;31m"   # bright red
elif [ "$PCT_INT" -ge 75 ]; then COLOR="\033[1;33m"   # bright yellow
elif [ "$PCT_INT" -ge 50 ]; then COLOR="\033[1;34m"   # bright blue
else                              COLOR="\033[1;32m"   # bright green
fi
RESET="\033[0m"

# ── Progress bar (10 chars wide) ─────────────────────────────────────────────
BAR_WIDTH=10
FILLED=$(( PCT_INT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=""
for ((i=0; i<FILLED; i++)); do BAR="${BAR}█"; done
for ((i=0; i<EMPTY;  i++)); do BAR="${BAR}░"; done

# ── Emit the status line ──────────────────────────────────────────────────────
printf "ctx: ${COLOR}${BAR}${RESET} ${COLOR}%s%%${RESET}\n" "$PCT_INT"
