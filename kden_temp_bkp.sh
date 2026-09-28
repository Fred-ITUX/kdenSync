#!/bin/bash
set -uo pipefail
if [ -f "$HOME/.bash_common" ]; then source "$HOME/.bash_common"; else echo "[CRITICAL ERROR] Bash module not found: "$HOME/.bash_common"" ; exit 1; fi          
DEBUG=false     ####    true     false



# BKPath="/media/federico/HDD2TB/Edit/Projects/2-TempBKP"
BKPath="$HOME/Downloads"

path="$HOME/Videos/Edit/Projects"


userChoice=$(find "$path" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort | fzf --height=40% --border --prompt="Choose the project to backup > ")


if [ -z "$userChoice" ]; then sysLogger e "No project selected, exiting"; exit 1; fi


projectFolder=""$path"/"$userChoice""
bkpFolder="$BKPath"/"$(get_file_date)"_"$userChoice"_BKP


foldersToBkp=(
    "kdenfiles"
    "stuff"
    # "robbba" #### legacy version
)


mkdir "$bkpFolder" || { sysLogger e "Backup folder creation failed"; }


for folder in "${foldersToBkp[@]}"; do
    f="$( find "$projectFolder"/ -type d -iname "*$folder*" )" 
    sysLogger DEBUG "Copying "$f" into "$bkpFolder""
    cp -r "$f" "$bkpFolder" || { sysLogger e "Copy failed "$f""; }
done





if [ -z "$(ls -A "$bkpFolder" )" ]; then
    sysLogger e "Backup folder appears to be empty."
else
    sysLogger DEBUG "Backup folder filled"
fi