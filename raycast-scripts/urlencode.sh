#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Url Encode
# @raycast.mode silent
# @raycast.packageName DevTools

# Optional parameters:
# @raycast.icon 🔗
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "text" }

# Documentation:
# @raycast.description Put UUID in clipboard
# @raycast.author sjurgemeyer
# @raycast.authorURL https://github.com/sjurgemeyer
#
#
printf %s $1|jq -sRr @uri | tee >(pbcopy)
