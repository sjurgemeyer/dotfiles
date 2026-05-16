#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
USED=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
TOTAL=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Pick bar color based on context usage
if [ "$PCT" -ge 90 ]; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

BRANCH=""
git rev-parse --git-dir > /dev/null 2>&1 && BRANCH=" | 🌿 $(git branch --show-current 2>/dev/null)"

fmt_tokens() {
  local n="$1"
  if   [ "$n" -ge 1000000 ]; then printf "%.1fM" "$(echo "scale=1; $n/1000000" | bc)"
  elif [ "$n" -ge 1000 ];    then printf "%dk"   "$(( n / 1000 ))"
  else                            echo "$n"
  fi
}

EFFORT_SUFFIX=""
[ -n "$EFFORT" ] && EFFORT_SUFFIX=" (effort $EFFORT)"

echo -e "${CYAN}[$MODEL]${RESET}${EFFORT_SUFFIX}"
echo -e "📁 ${DIR##*/}$BRANCH"
COST_FMT=$(printf '$%.2f' "$COST")
USED_FMT=$(fmt_tokens "$USED")
TOTAL_FMT=$(fmt_tokens "$TOTAL")
DIM='\033[2m'
echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% ${DIM}(${USED_FMT} / ${TOTAL_FMT})${RESET} | ${YELLOW}${COST_FMT}${RESET} | ⏱️ ${MINS}m ${SECS}s"

if [ -f /tmp/claude-last-tokens.txt ]; then
  IFS=',' read -r t_inp t_cr t_cc t_out < /tmp/claude-last-tokens.txt
  t_total=$(( t_inp + t_cr + t_cc ))
  CACHE_NOTE=""
  [ "$t_cr" -gt 0 ] && CACHE_NOTE=" ${DIM}($(fmt_tokens $t_cr) cached)${RESET}"
  echo -e "${DIM}last response:${RESET} ${CYAN}↑$(fmt_tokens $t_total)${RESET}${CACHE_NOTE} ${YELLOW}↓$(fmt_tokens $t_out)${RESET}"
fi
