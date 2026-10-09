#! /bin/bash


ERR_MISSING_TARGET="missing_target"
ERR_INVALID_PERIOD="invalid_period"
ERR_TARGET_PERIOD_TAKEN="target_period_taken"
ERR_DESTINATION_PERIOD_TAKEN="destination_period_taken"
ERR_MULTIPLE_TARGETS_FOUND="multiple_targets_found"


imageQuality="50%"
thumbnailResolution="640x480"
compressedResolution="1920x1080"
mode=$APP_ENV

if [[ $mode == "production" ]]; then
	 timePeriod=$1
	 delimiter=$2
	 targetPath=$3
	 serverPath=$4
	 destinationPath=$5
	 watermarkPath=$6
	 uploadToServer=$7
	 alpha=$8
	 #magic="composite"
else 
	 timePeriod="10.15"
	 delimiter=".NEF"
	 targetPath="/data/test_input/photos/NIKON D5600/DCIM"
	 serverPath=""
	 destinationPath="/data/test_output/photos/2025/2/1"
	 watermarkPath="/data/test_input/watermark/watermark.png"
	 uploadToServer="false"
	 alpha="0.5"
	 #magic="magick composite"
fi

if [[ $timePeriod == "9.15" ]]; then 
	 f_name="9.15"
elif [[ $timePeriod == "10.15" ]]; then
	 f_name="10.15"
elif [[ $timePeriod == "11.15" ]]; then
	 f_name="11.15"
elif [[ $timePeriod == "12.15" ]]; then
	 f_name="12.15"
elif [[ $timePeriod == "13.15" ]]; then
	 f_name="13.15"
elif [[ $timePeriod == "14.15" ]]; then
	 f_name="14.15"
else 
	 printf $ERR_INVALID_PERIOD
	 exit 1
fi

ls "$targetPath/"10[!.]* 1> /dev/null 2>&1
if [[ $? != 0 ]]; then
	 echo "Did not find any pictures on sdcard."
	 exit 1
fi

if [[ -d "$targetPath/$timePeriod" ]]; then
 printf $ERR_TARGET_PERIOD_TAKEN
 exit 1
fi

if [[ -d "$destinationPath/$timePeriod" ]]; then
 printf $ERR_DESTINATION_PERIOD_TAKEN
 exit 1
fi

targetFolder=$(ls -trd -- "$targetPath/"10[!.]* 2>/dev/null) 
targetFolders=("$targetPath/"10[!.]*)
totalTargetFolders=${#targetFolders[@]}

if [[ $totalTargetFolders != 1 ]];then 
	 printf $ERR_MULTIPLE_TARGETS_FOUND
	 exit 1
fi

mkdir -p "$destinationPath/$timePeriod/videos/"{thumbnails,originals,compressed}
mkdir -p "$destinationPath/$timePeriod/1/"{originals,thumbnails,compressed}

base=$(basename "$targetFolder")
filess="$(ls "$targetPath/$base/"* | sort -V)"
IFS=$(echo -en "\n\b")
folder_total=${#files[@]} 

n_counter=1
i=0
borderFiles=("$targetPath/$base/"*.NEF)
totalBorderFiles=${#borderFiles[@]}

files=()
for f in $filess; do
	 files+=("$f")
done

for i in ${!files[@]};do

	 has_break_point=$( ls "${files[$i]}" | grep $delimiter )
	 if [[ $has_break_point != "" ]];then
			(( n_counter=n_counter+1 ))
			if [[ $n_counter -le $totalBorderFiles ]]; then
				 mkdir -p "$destinationPath/$timePeriod/$n_counter/"{originals,thumbnails,compressed}
			fi
	 else
			base=$(basename "${files[$i]}")
			cp "${files[$i]}" "$destinationPath/$timePeriod/$n_counter/"originals

			magick composite -dissolve 25 -tile -quality ${imageQuality}% "$watermarkPath" -quality ${imageQuality}% "${files[$i]}" -resize $compressedResolution "$destinationPath/$timePeriod/$n_counter/compressed/$base" || exit 1

			is_ext=$( ls "${files[(($i+1))]}" | grep $delimiter )
			if [[ $is_ext != "" ]]; then
				 magick "${files[$i]}" -resize "$thumbnailResolution" "$destinationPath/$timePeriod/$n_counter/thumbnails/thumbnail.jpg" || exit 1
			fi
	 fi
done

mv "$targetPath/"10[!.]* "$targetPath/$timePeriod"

#if [[ $upload == "true" ]]; then 
	 #echo "back up incomplete"
#fi

printf "done"




