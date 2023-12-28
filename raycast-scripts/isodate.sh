#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ISO-8601 Date
# @raycast.mode silent
# @raycast.packageName DevTools

# Optional parameters:
# @raycast.icon 📅
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Put current timestmap onto clipboard
# @raycast.author sjurgemeyer
# @raycast.authorURL https://github.com/sjurgemeyer

date -u +"%Y-%m-%dT%H:%M:%SZ" | tee >(pbcopy)
