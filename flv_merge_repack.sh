#!/bin/bash

# Setup
myPath=`pwd`
cd $myPath
echo "current dir: $myPath"

# Merge Mode Code
SinglePackMode=1
MultiPackMode=2

KEEP_ORIGINAL='Y'
NOT_KEEP_ORIGINAL='N'
VERBOSE_MODE='V'

# StartUp
read -p "Merge Mode: (1 - Single-Pack, 2 - Multi-Pack): " merge_mode
read -p "OriginalFileKeep (Y/N): " file_mode_input

file_mode=$(echo $file_mode_input | tr "[a-z]" "[A-Z]") 
if [ $file_mode == $KEEP_ORIGINAL ]; then
	echo "Confirmed Mode: $merge_mode with OriginalFileKeep On"
else if [ $file_mode == $NOT_KEEP_ORIGINAL ]; then
	echo "Confirmed Mode: $merge_mode with OriginalFileKeep Off"
else if [ $file_mode == $VERBOSE_MODE ]; then
	echo "Confirmed Mode: $merge_mode with OriginalFileKeep On in VerboseMode"
fi

# Find all the flv fragment videos' filenames in current dir
# with filenames written into filelist.txt
find . -maxdepth 1 -name '*.flv' > ./filelist.txt
sed -i -e "s|./||g" ./filelist.txt

if [ $merge_mode == $SinglePackMode ]; then

	# Filename Modify
	sed -i -e "s/^/file '&/g" ./filelist.txt
	sed -i -e "s/$/'&/g" ./filelist.txt

	# Sort filenames with output written into anohter filelist
	sort -t '-' -k 1,1 -k 2,2n ./filelist.txt > ./filelist_sorted.txt

	# Video concating by ffmpeg
	ffmpeg -f concat -i ./filelist_sorted.txt -c copy ./output.flv

	# Repack the merged flv video with mp4
	find . -name '*.flv' | parallel ffmpeg -i "{}" -c copy -movflags +faststart "{.}".mp4 \;

	# Rename the output with the original filename
	sed -i -e "s|^file '||g" ./filelist_sorted.txt 
	sed -i -e "s/'$//g" ./filelist_sorted.txt
	sed -n '1p' ./filelist_sorted.txt | cut -f 1 -d '-' | xargs -I {} mv './output.mp4' './{}.mp4'

elif [ $merge_mode == $MultiPackMode ]; then

	awk -F '-' '{print $1}' ./filelist.txt | sort -u > ./pack_category.txt

	for i in `cat ./pack_category.txt`
	do
		echo $i | xargs -I {} grep -n {} ./filelist.txt > ./pack_$i.txt

		# Filename Modify
		sed -i -e "s|^[0-9]*:||g" ./pack_$i.txt
		sed -i -e "s/^/file '&/g" ./pack_$i.txt
		sed -i -e "s/$/'&/g" ./pack_$i.txt

		# Sort filenames with output written into anohter filelist
		sort -t '-' -k 1,1 -k 2,2 ./pack_$i.txt | sort -o ./pack_$i.txt
	done

	# Video concating One by One
	patt = /'pack_[0-9]{1,}$.txt'/
		
	for i in `cat ./pack_category.txt`
	do
		for j in $(basename ./pack_$i.txt)
		do
			ffmpeg -f concat -i $j -c copy ./output_$i.flv
		done
	done 

	# Repack the merged flv video with mp4
	find . -name 'output_*.flv' | parallel ffmpeg -i "{}" -c copy -movflags +faststart "{.}".mp4 \;

fi

rm ./*.txt-e
rm ./*-*.mp4

if [ $file_mode != VERBOSE_MODE ]; then 
	
	rm ./pack_*.txt
	rm ./filelist*.txt

	if [ $file_mode != KEEP_ORIGINAL ]; then

		# Remove the original files
		rm ./*-*.flv
		rm ./*.flv	
	fi
fi

