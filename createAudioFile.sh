#!/bin/bash
# Grab the most recent file from a director (assume it's a video file)
# Convert to an audio file

video_dir=$HOME/Desktop
attachments_path=$HOME/Documents/Notes/Transcripts
file_name=`ls -tUc1 $video_dir | head -n 1`

while getopts d: option
do
    case "${option}"
    in
        i) video_dir=${OPTARG};;
        o) attacments_path=${OPTARG};;
        f) file_name=${OPTARG};;
    esac
done


filename_without_extension="${file_name%.*}"
new_filename="${filename_without_extension/CleanShot /Audio Transcript }"
ffmpeg -i "$HOME/Desktop/$file_name" -vn -acodec copy "$attachments_path/$new_filename.m4a"
