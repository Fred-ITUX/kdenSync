#!/bin/bash
set -euo pipefail
if [ -f "$HOME/.bash_common" ]; then source "$HOME/.bash_common"; else echo "[CRITICAL ERROR] Bash module not found: "$HOME/.bash_common"" ; exit 1; fi          
DEBUG=false     ####    true     false



ProjectTemplate="$HOME/Nextcloud/Kden/Other/Templates/ProjectTemplate.kdenlive"
descriptionTemplate="$HOME/Nextcloud/Kden/Other/Docs/DescriptionUT.txt"

read -p "Project name: " projectName 


projectName=$( stringNoBlanks "$projectName")

if [ -z "$projectName" ]; then echo "No name give, exiting"; exit 1; fi

path=""$HOME"/Videos/Edit/Projects/"$projectName""

descFile=""$path"/desc_"$projectName".txt"


mkdir "$path" || { sysLogger e "Project's folder creation failed"; exit 1; }


folderList=( 
    "1-"$projectName"_stuff"
    "2-KdenFiles"
    "3-Video"
    "4-Thumbnail"
    "5-Stream"
    "6-proxy"
    "7-Parts"
    "8-Extra"
    "9-Effects"
)


for folder in "${folderList[@]}";do
    mkdir ""$path"/"$folder"" || { sysLogger e "Folder creation failed for: "$folder""; }
done



cat "$descriptionTemplate" > "$descFile" 


cp "$ProjectTemplate" ""$path"/2-KdenFiles/"$projectName"_main.kdenlive"
cp "$ProjectTemplate" ""$path"/2-KdenFiles/"$projectName"_main_2.kdenlive"