#!/bin/bash

i=1

while IFS= read -r playlist_link; do
	ffmpeg -i "$playlist_link" -c copy "${i}.mp4"
	((i++))
done < thelist.txt
