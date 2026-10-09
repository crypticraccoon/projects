#!/bin/bash

ERR_MISSING_TARGET="missing_target"
ERR_INVALID_PERIOD="invalid_period"
ERR_INVALID_ARG="invalid_arg"
ERR_TARGET_PERIOD_TAKEN="target_period_taken"
ERR_DESTINATION_PERIOD_TAKEN="destination_period_taken"
ERR_MULTIPLE_TARGETS_FOUND="multiple_targets_found"

mode=$APP_ENV

if [[ $mode == "production" ]]; then
	 delimiter=$1
	 targetPath=$2
	 timePeriod=$3
	 joinFolders=$4
	 destinationPath=$5
else 
	 delimiter=".NEF"
	 targetPath="$HOME/ps/data/test_input/photos/NIKON D5600/DCIM"
	 timePeriod="9.15"
	 joinFolders="true"
	 destinationPath="$HOME/ps/data/test_output/photos/2025/2/1"
fi


ls "$targetPath/"10[!.]* 1> /dev/null 2>&1
if [[ $? != 0 ]]; then
	 printf $ERR_MISSING_TARGET
	 exit 1
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

if [[ $joinFolders != "false" ]] && [[ $joinFolders != "true" ]];then 
	 printf $ERR_INVALID_ARG
	 exit 1
fi

ls $targetPath/$timePeriod 1> /dev/null 2>&1
if [[ $? == 0 ]]; then
	 printf $ERR_TARGET_PERIOD_TAKEN
	 exit 1
fi

ls $destinationPath/$timePeriod 1> /dev/null 2>&1
if [[ $? == 0 ]]; then
 printf $ERR_DESTINATION_PERIOD_TAKEN
 exit 1
fi


targetFiles=("$targetPath/"10[!.]*)
targetFolders=("$targetPath/"10[!.]*)
totalTargetFolders=${#targetFolders[@]}

shopt -s nullglob
if [[ $totalTargetFolders -gt 1 ]] && [[ $joinFolders == "false" ]]; then 
	 printf $ERR_MULTIPLE_TARGETS_FOUND
	 exit 1
elif [[ $totalTargetFolders -gt 1 ]] && [[ $joinFolders == "true" ]]; then

	 mkdir "$targetPath/$timePeriod"_joined
	 for i in ${!targetFolders[@]}; do
			mv "${targetFolders[$i]}" "$targetPath/${timePeriod}"_joined
	 done
	 mkdir "${targetFolders[0]}"
	 target_folder="${targetFolders[0]}"

	 lastCount=1
	 for i in ${!targetFolders[@]}; do
			base=$(basename "${targetFolders[$i]}")
			focusedFiles=("$targetPath/${timePeriod}_joined/$base/"*)
			totalFocusedFiles=${#focusedFiles[@]}
			for o in ${!focusedFiles[@]}; do
				 fileName="${focusedFiles[$o]}"
				 if [[ $i == 0 ]] && [[ $((o+1)) == $totalFocusedFiles ]];then 
						(( lastCount = $((o+1)) ))
				 fi

				 if [[ $i != 0 ]];then
						((lastCount=lastCount+1))
				 fi

				 if [[ $(ls "$fileName" | grep .NEF) != "" ]];then 
						if [[ $i != 0 ]];then
							cp "${focusedFiles[$o]}" "${targetFolders[0]}/"$((lastCount-1)).NEF
						else
							 cp "${focusedFiles[$o]}" "${targetFolders[0]}/"$((o-1)).NEF
						fi
				 else 
						if [[ $i != 0 ]];then
							 cp "${focusedFiles[$o]}" "${targetFolders[0]}/${lastCount}.JPEG"
						else
							 cp "${focusedFiles[$o]}" "${targetFolders[0]}/${o}.JPEG"
						fi
				 fi
			done
 done
fi

counter=0
for i in "$targetFiles"/*; do
	 has_break_point=$(ls "$i" | grep $delimiter)
	 if [[ $has_break_point != "" ]];then
			(( counter=counter+1 ))
	 fi
done

printf ${counter}

