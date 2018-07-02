#!/bin/bash

# Setup
myPath=`pwd`
cd $myPath
echo $myPath

# Find all the flv fragment videos' filenames in current dir
# with filenames written into filelist.txt
find . -maxdepth 1 -name '*.flv' > $myPath/filelist.txt
sed -i -e "s|\./||g" $myPath/filelist.txt
sed -i -e "s/^/file '&/g" $myPath/filelist.txt
sed -i -e "s/$/'&/g" $myPath/filelist.txt

# Sort filenames with output written into anohter filelist
sort -n -t- -k2 $myPath/filelist.txt > $myPath/filelist_sorted.txt

# Video concating by ffmpeg
ffmpeg -f concat -i $myPath/filelist_sorted.txt -c copy $myPath/output.flv

# Rename the output.flv with the original filename
sed -n '1p' $myPath/filelist_sorted.txt | cut -c 7-14 | xargs -I {} mv $myPath/output.* {}.flv

# Remove the original files
rm $myPath/*-*.flv

# Repack the merged flv video with mp4
find $myPath -name '*.flv' | parallel ffmpeg -i "{}" -c copy -movflags +faststart "{.}".mp4 \;

# Remove the merged flv video & interim filelist.txt
rm $myPath/*.flv
rm $myPath/filelist.txt*
