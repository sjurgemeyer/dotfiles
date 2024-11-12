#!/bin/bash
# Grab the most recent file from a director (assume it's a video file)
# Convert to an audio file

video_dir=$HOME/Desktop
attachments_path=$HOME/Documents/Notes/Attachments/

while getopts d: option
do
    case "${option}"
    in
        i) video_dir=${OPTARG};;
        o) attacments_path=${OPTARG};;
    esac
done

filename=`ls -tUc1 $video_dir | head -n 1`

filename_without_extension="${filename%.*}"
ffmpeg -i "$HOME/Desktop/$filename" -vn -acodec copy "$attachments_path/$filename_without_extension.m4a"
