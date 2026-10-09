#!/bin/bash

ERR_MISSING_TARGET="missing_target"
ERR_MISSING_DESTINATION="missing_destination"
ERR_INVALID_PERIOD="invalid_period"
ERR_INVALID_ARG="invalid_arg"
ERR_TARGET_PERIOD_TAKEN="target_period_taken"
ERR_DESTINATION_PERIOD_TAKEN="destination_period_taken"
ERR_MULTIPLE_TARGETS_FOUND="multiple_targets_found"

fileType="MP4"
thumbnailFileType="jpg"
cropResolution="1080x1440" 
compressedVideoScale="1080"

#mode=$APP_ENV

#if [[ $mode == "production" ]]; then
	 #targetPath="/Volume"
	 destinationPath=$2
	 watermarkPath=$3 
	 #timePeriod=$4
	 uploadToServer=$5
	 serverPath=$6
	 alpha=$7
	 append=$8
	 magick="convert"
#else 
	 #targetPath="$HOME/ps/data/test_input/videos/NIKON D5500/DCIM/"
	 #destinationPath="$HOME/ps/data/test_output/photos/2025/2/7"
	 #watermarkPath="$HOME/ps/data/test_input/watermarks/watermark/watermark.png"
	 #timePeriod="10.15"
	 #uploadToServer="false"
	 #serverPath="."
	 #alpha="0.5"
	 #append="false"
	 #magick="magick"
#fi

targetDir="/Volumes"
if [ ! -d "$targetDir" ]; then
    echo $ERR_MISSING_TARGET
    exit 1
fi

targetDirItems=("$targetDir"/*)
targetDirCount=${#targetDirItems[@]

echo "Select folder index [Eg. 1]: "
for ((i=0; i<targetDirCount; i++)); do
    echo "$i: ${targetDirItems[i]}"
done

read -p "Enter the index number: " targetPath

ls "$targetPath/"10[!.]* 1> /dev/null 2>&1
if [[ $? != 0 ]]; then
	 printf $ERR_MISSING_TARGET
	 exit 1
fi



targetFolder=$(ls -trd -- "$targetPath/10"[!.]* 2>/dev/null) 
targetFolders=("$targetPath/10"[!.]*)
targetFolderCount=${#targetFolders[@]}

if [[ $targetFolderCount != 1 ]];then 
	 printf $ERR_MULTIPLE_TARGETS_FOUND
	 exit 1
fi

echo -e "Please select a timeframe:
1: 9.15
2: 10.15
3: 11.15
4: 12.15
5: 13.15
6: 14.15
"
read -p "Select a time frame:  " timeIndex 


if [[ $timeIndex == "1" ]]; then 
	 timePeriod="9.15"
elif [[ $timeIndex == "2" ]]; then
	 timePeriod="10.15"
elif [[ $timeIndex == "3" ]]; then
	 timePeriod="11.15"
elif [[ $timeIndex == "4" ]]; then
	 timePeriod="12.15"
elif [[ $timeIndex == "5" ]]; then
	 timePeriod="13.15"
elif [[ $timeIndex == "6" ]]; then
	 timePeriod="14.15"
else 
	 printf $ERR_INVALID_PERIOD
	 exit 1
fi

if [[ ! -d $(~/Desktop/$(date +"%a_%b_%y") 2> /dev/null) ]]; then 
	 mkdir ~/Desktop/$(date +"%a_%b_%y")
fi
destinationPath="~/Desktop/$(date +"%a_%b_%y")"

if [[ ! -d $destinationPath ]]; then 
	 printf $ERR_MISSING_DESTINATION
	 exit 1
fi

#if [[ $append != "false" ]] && [[ $append != "true" ]];then 
	 #printf $ERR_INVALID_ARG
	 #exit 1
#fi
#merge="n"
if [[ -d "$targetPath/$timePeriod" ]]; then 
	 read -p "The time period: $timePeriod is already taken. Would you like to merge folders? [y/n] " merge 

	 if [[ $merge == "y" ]];then 
			mv "$targetPath/$timePeriod" "$targetPath/${tmePeriod}_$(date +%y_%m_%d_%H_%M)"
	 elif [[ $merge == "n" ]]; then 
			echo "Time period already exists."
			exit 1
	 elif [[ $merge != "y" || $merge != "n" ]];then 
			echo "Invalid choice."
			exit 
	 fi
fi

#Error Message: Missing time period at destination path 
if [[ ! -d "$destinationPath/$timePeriod" ]]; then 
	 mkdir "$destinationPath/$timePeriod"
	 #printf $ERR_MISSING_PERIOD
	 #exit 1
fi

targetFiles=("$targetPath/10"[!.]*/*)
targetFileCount=${#targetFiles[@]}

destinationImageFolders=("$destinationPath/$timePeriod/"[!video]*)
destinationImageCount=${#destinationImageFolders[@]}

holder=0
if [[ $append == "true" ]]; then
	 holderFiles=("$destinationPath/$timePeriod/videos/originals/"*)
	 holderFilesCount=${#holderFiles[@]}
	 holder=$holderFilesCount
fi

for i in ${!targetFiles[@]}; do 
	 x=$i
	 if [[ $append == "true" ]]; then
			((i=i+holder))
	 fi

	 cp "${targetFiles[$x]}" "$destinationPath/$timePeriod/videos/originals/$(($i + 1)).$fileType"

	 ffmpeg -i "${targetFiles[$x]}" -vf "select=eq(n\,60)" -vframes 1 "$destinationPath/$timePeriod/videos/thumbnails/$(($i + 1)).$thumbnailFileType" 2>/dev/null || exit 1

	 $magick "$destinationPath/$timePeriod/videos/thumbnails/$(($i + 1)).$thumbnailFileType" -gravity center -crop ${cropResolution}+0+0 "$destinationPath/$timePeriod/videos/thumbnails/$(($i + 1)).$thumbnailFileType" 2>/dev/null

	ffmpeg -y -i "${targetFiles[$x]}" -i "$watermarkPath" \
			 -filter_complex "[1]format=rgba,colorchannelmixer=aa=$alpha[logo];[0][logo]overlay=(W-w)/2:(H-h)/2:format=auto,scale=$compressedVideoScale:-2" \
			 -crf 28  \
			 -c:a copy \
			 "$destinationPath/$timePeriod/videos/compressed/$(($i + 1)).$fileType" 2>/dev/null || exit 1
done

mv "$targetPath/10"[!.]* "$targetPath/$timePeriod"

printf "ok"

