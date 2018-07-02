#!/bin/bash

myPath=`pwd`
cd $myPath
echo $myPath

find . -maxdepth 1 -name '*.flv' > $myPath/filelist.txt
sed -i -e "s|\./||g" $myPath/filelist.txt
sed -i -e "s/^/file '&/g" $myPath/filelist.txt
sed -i -e "s/$/'&/g" $myPath/filelist.txt

sort -n -t- -k2 $myPath/filelist.txt > $myPath/filelist_sorted.txt

ffmpeg -f concat -i $myPath/filelist_sorted.txt -c copy $myPath/output.flv

sed -n '1p' $myPath/filelist_sorted.txt | cut -c 7-14 | xargs -I {} mv $myPath/output.* {}.flv

rm $myPath/*-*.flv

find $myPath -name '*.flv' | parallel ffmpeg -i "{}" -c copy -movflags +faststart "{.}".mp4 \;

rm $myPath/*.flv
rm $myPath/filelist.txt
