#!/bin/sh
# Loads prreview configuration into PRREVIEW_* variables, creating a default
# config file on first run. Must be sourced, not executed:
#   . "$HOME/projects/dotfiles/cli/prreview/prreview-config.sh"
PRREVIEW_CONF_DIR="$HOME/.config/prreview"
PRREVIEW_CONF_FILE="$PRREVIEW_CONF_DIR/prreview.conf"

if [ ! -f "$PRREVIEW_CONF_FILE" ]; then
  mkdir -p "$PRREVIEW_CONF_DIR"
  default_user=$(gh api user --jq .login 2>/dev/null)
  cat > "$PRREVIEW_CONF_FILE" <<EOF
# prreview configuration

# GitHub username, used to match your own PRs for the "My PRs" filter.
PRREVIEW_GITHUB_USER="${default_user}"

# Repos to search, as "owner/repo", space-separated. Leave empty to
# auto-discover via \`gh api user/subscriptions\` (everything you're watching).
PRREVIEW_REPOS=""

# Which status icons to show in the STATUS column.
PRREVIEW_SHOW_BUILD=true
PRREVIEW_SHOW_APPROVAL=true
PRREVIEW_SHOW_UPTODATE=true
PRREVIEW_SHOW_UNRESOLVED=true

# Base URL for linking Jira ticket references found in PR titles, e.g.
# "[EDP-854]" links to "\$PRREVIEW_JIRA_URL/EDP-854". Leave empty to disable.
PRREVIEW_JIRA_URL=""
EOF
fi

# Defaults if the config file omits a setting.
PRREVIEW_GITHUB_USER=""
PRREVIEW_REPOS=""
PRREVIEW_SHOW_BUILD=true
PRREVIEW_SHOW_APPROVAL=true
PRREVIEW_SHOW_UPTODATE=true
PRREVIEW_SHOW_UNRESOLVED=true
PRREVIEW_JIRA_URL=""

# shellcheck disable=SC1090
. "$PRREVIEW_CONF_FILE"
