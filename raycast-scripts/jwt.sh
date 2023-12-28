#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JWT decode
# @raycast.mode fullOutput
# @raycast.packageName DevTools

# Optional parameters:
# @raycast.icon 🔐
# @raycast.needsConfirmation false
# @raycast.argument1 { "type": "text", "placeholder": "token" }

# Documentation:
# @raycast.description Decode JWT token
# @raycast.author sjurgemeyer
# @raycast.authorURL https://github.com/sjurgemeyer
#
jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1 | tee >(pbcopy)
