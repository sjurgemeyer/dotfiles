#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title UUID
# @raycast.mode silent
# @raycast.packageName DevTools

# Optional parameters:
# @raycast.icon 🔢
# @raycast.needsConfirmation false

# Documentation:
# @raycast.description Put UUID in clipboard
# @raycast.author sjurgemeyer
# @raycast.authorURL https://github.com/sjurgemeyer
#
uuidgen | tee >(pbcopy)
