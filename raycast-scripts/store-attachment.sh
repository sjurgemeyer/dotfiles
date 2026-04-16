#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Store Attachment
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📔 
# @raycast.argument1 { "type": "text", "placeholder": "File name" }
# @raycast.packageName Shaun's scripts

# Documentation:
# @raycast.description Move the latest screenshot taken to Obsidian's Attacments folder with the given name
# @raycast.author shaun_jurgemeyer
# @raycast.authorURL https://raycast.com/shaun_jurgemeyer


image_dir=$HOME/Documents
attachments_path=$HOME/Documents/Notes/Attachments
file_name=`ls -tUc1 $image_dir | head -n 1`

while getopts d: option
do
    case "${option}"
    in
        i) image_dir=${OPTARG};;
        o) attacments_path=${OPTARG};;
        f) file_name=${OPTARG};;
    esac
done

extension="${file_name##*.}"
new_filename="$1"
mv "$image_dir/$file_name" "$attachments_path/$new_filename.$extension"

