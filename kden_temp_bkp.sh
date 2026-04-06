#!/bin/bash
if [ -f "$HOME/.bash_UT"        ]; then . "$HOME/.bash_UT"       ; else echo -e "[CRITICAL ERROR] Bash module not found: $HOME/.bash_UT"       ; exit 1; fi        


BKPath="/media/federico/SSD1TB/Projects/2-TempBKP"

path="$HOME/Videos/Edit/Projects"

echo -e "Choose the project to backup:"


userChoice=$(ls "$path" | fzf --height=20% --border --prompt="Project > ")


if [ -z "$userChoice" ]; then sysLogger e "No project selected, exiting"; exit 1; fi


fileList=$(ls "$path/$userChoice")


kdenFolder="$path/$userChoice/"$( echo -e "$fileList" | grep -i "kdenfiles" ) #### kdenFolder="$path/$userChoice/2-KdenFiles"


robbbaFolder="$path/$userChoice/"$(echo -e "$fileList" | grep -i "ROBBBA" ) #### robbbaFolder="$path/$userChoice/1-"$userChoice"_ROBBBA"


bkpFolder="$BKPath"/"$(get_file_date)"_"$userChoice"_BKP
mkdir "$bkpFolder"


cp -r "$kdenFolder" "$bkpFolder"
cp -r "$robbbaFolder" "$bkpFolder"

if [ -d "$bkpFolder" ]; then

    if [ "$(ls -A "$bkpFolder" )" ]; then sysLogger i "Files copied to $bkpFolder"    
    else sysLogger e "Folder created but file not copied $bkpFolder"; fi

else sysLogger e "Error creating backup folder $bkpFolder"; fi