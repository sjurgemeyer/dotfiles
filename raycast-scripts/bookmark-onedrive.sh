#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Bookmark OneDrive Document
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📎
# @raycast.argument1 { "type": "text", "placeholder": "tags (e.g. #project #important)", "optional": true }
# @raycast.packageName OneDrive Bookmarks

# Documentation:
# @raycast.description Bookmark the current Chrome tab (OneDrive document) into Obsidian
# @raycast.author sjurgemeyer

VAULT_PATH="$HOME/Documents/Notes"
BOOKMARK_FOLDER="Bookmarks"
TAGS_INPUT="${1:-}"

# Get URL and title from Chrome's active tab
TAB_INFO=$(osascript -e '
tell application "Google Chrome"
    set tabURL to URL of active tab of front window
    set tabTitle to title of active tab of front window
    return tabURL & "|||" & tabTitle
end tell' 2>&1)

if [ $? -ne 0 ]; then
    echo "Failed to get Chrome tab info. Is Chrome running?"
    exit 1
fi

TAB_URL="${TAB_INFO%%|||*}"
TAB_TITLE="${TAB_INFO##*|||}"

# Validate it looks like a OneDrive/SharePoint URL
if [[ ! "$TAB_URL" =~ sharepoint\.com|onedrive\.live\.com|1drv\.ms ]]; then
    echo "Current tab doesn't appear to be a OneDrive/SharePoint document: $TAB_URL"
    exit 1
fi

# Clean up the title - remove common suffixes added by SharePoint/OneDrive
CLEAN_TITLE=$(echo "$TAB_TITLE" | sed -E 's/ - [A-Za-z]+ Online$//; s/ \| Microsoft [0-9]+$//; s/\.docx$//; s/\.xlsx$//; s/\.pptx$//; s/\.pdf$//')

# Parse tags from input - accept "#tag1 #tag2" or "tag1 tag2" format
TAGS_YAML=""
if [ -n "$TAGS_INPUT" ]; then
    # Strip # symbols, split by spaces, build YAML array
    CLEANED_TAGS=$(echo "$TAGS_INPUT" | sed 's/#//g' | xargs)
    TAGS_YAML=""
    for tag in $CLEANED_TAGS; do
        TAGS_YAML="${TAGS_YAML}
  - ${tag}"
    done
fi

# Build the full tags block (always include 'onedrive')
ALL_TAGS="tags:
  - onedrive${TAGS_YAML}"

# Sanitize title for filename - remove/replace problematic characters
SAFE_FILENAME=$(echo "$CLEAN_TITLE" | sed -E 's/[\/\\:*?"<>|]/-/g; s/  +/ /g; s/^ +//; s/ +$//')

# Ensure bookmark folder exists
mkdir -p "${VAULT_PATH}/${BOOKMARK_FOLDER}"

# Build the note
FILE_PATH="${VAULT_PATH}/${BOOKMARK_FOLDER}/${SAFE_FILENAME}.md"

TODAY=$(date +%Y-%m-%d)

cat > "$FILE_PATH" << EOF
---
title: "${CLEAN_TITLE}"
source: ${TAB_URL}
${ALL_TAGS}
icon: LiBookmark
created: ${TODAY}
---

# [${CLEAN_TITLE}](${TAB_URL})

## Notes

EOF

# Open in Obsidian
VAULT_NAME=$(basename "$VAULT_PATH")
ENCODED_PATH=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${BOOKMARK_FOLDER}/${SAFE_FILENAME}'))")
open "obsidian://open?vault=${VAULT_NAME}&file=${ENCODED_PATH}"

echo "Bookmarked: ${CLEAN_TITLE}"
