#!/bin/bash
set -euo pipefail
if [ -f "$HOME/.bash_common" ]; then source "$HOME/.bash_common"; else echo "[CRITICAL ERROR] Bash module not found: "$HOME/.bash_common"" ; exit 1; fi          
DEBUG=false     ####    true     false


path="$HOME/Videos/Edit/Projects"

ext=".kdenlive"

if [ ! -d "$path" ]; then
    sysLogger e "Folder "$path" not found, exiting"; exit 1
fi

#### Fuzzy find the project
userChoice=$(find "$path" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort | fzf --height=40% --border --prompt="Project > ")

projectFolder=""$path"/"$userChoice""

sysLogger DEBUG "Project folder: $projectFolder"


#### Match case-insensitive the literal string 'kdenfile' in a folder's name
kdenFilesFolder=$( find "$projectFolder"/ -type d -iname "*kdenfile*" )


if [ -z "$kdenFilesFolder" ] || [ ! -d "$kdenFilesFolder" ]; then
    sysLogger e "Invalid folder: "$kdenFilesFolder""; exit 1
fi


bkpFolder=""$kdenFilesFolder"/bkp_"$(get_file_date)""

mkdir -p "$bkpFolder" || { sysLogger e "Backup folder creation failed"; exit 1; }

sysLogger DEBUG "Creating folder "$bkpFolder""



sysLogger DEBUG "Backing up all '.kdenlive' files under ""$kdenFilesFolder"""
find "$kdenFilesFolder" -mindepth 1 -maxdepth 1 -type f -iname "*${ext}" -exec cp -t "$bkpFolder" {} +


mainFile="$(find "$kdenFilesFolder" -mindepth 1 -maxdepth 1 -type f -regextype posix-extended -iregex '.*/.*_main\.'"${ext:1}"'$')"

sysLogger DEBUG "Main file found: "$mainFile""


sysLogger DEBUG "Overwriting every 'main_X.kdenlive' with the original 'main'"
find "$kdenFilesFolder" -mindepth 1 -maxdepth 1 -type f -regextype posix-extended -iregex '.*/.*_main_[0-9]+'"${ext}"'$' -exec cp "$mainFile" {} \;

if [ -z "$(ls -A "$bkpFolder" )" ]; then
    sysLogger e "Backup folder appears to be empty."
else
    sysLogger DEBUG "Backup folder filled"
fi