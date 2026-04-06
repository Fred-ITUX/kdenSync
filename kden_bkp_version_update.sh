#!/bin/bash
if [ -f "$HOME/.bash_aliases"   ]; then . "$HOME/.bash_aliases"  ; else echo -e "[CRITICAL ERROR] Bash module not found: $HOME/.bash_aliases"  ; exit 1; fi
if [ -f "$HOME/.bash_functions" ]; then . "$HOME/.bash_functions"; else echo -e "[CRITICAL ERROR] Bash module not found: $HOME/.bash_functions"; exit 1; fi
if [ -f "$HOME/.bash_UT"        ]; then . "$HOME/.bash_UT"       ; else echo -e "[CRITICAL ERROR] Bash module not found: $HOME/.bash_UT"       ; exit 1; fi          

path="$HOME/Videos/Edit/Projects"

userChoice=$(ls "$path" | fzf --height=20% --border --prompt="Project > ")

fileList=$(ls "$path/$userChoice")


if [ -z "$userChoice" ]; then sysLogger e "No project selected. Exiting."; exit 1; fi


kdenFolder="$userChoice/"$( echo -e "$fileList" | grep -i "kdenfiles" )

kdenFilesPath="$path/$kdenFolder"

echo -e "Kden Files Path: $kdenFilesPath\n"

cd "$kdenFilesPath"

echo -e "Choose the version to backup:"

firstFile=$(ls "$kdenFilesPath" | fzf --height=20% --border --prompt="File > ")


if [ -z "$firstFile" ]; then sysLogger e "No file selected. Exiting."; exit 1 ; fi


ext=".kdenlive"

#### If matches, remove the .kdenlive
if [[ $firstFile == *"$ext" ]]; then base="${firstFile%"$ext"}"
else sysLogger e "Filename doesn't end in $ext"; exit 1; fi

#### Pull off the trailing underscore + digits
if [[ $base =~ ^(.+)_([0-9]+)$ ]]; then

prefix="${BASH_REMATCH[1]}"
num="${BASH_REMATCH[2]}"

else sysLogger e "No trailing _number found in $base"; exit 1; fi



#### Increment the version number ( ..._X.kdenlive )
secondNum=$(( num + 1 ))
thirdNum=$(( secondNum + 1 ))


secondFile="${prefix}_${secondNum}${ext}"
thirdFile="${prefix}_${thirdNum}${ext}"


#### Files exists, proceed with update and backup
if [ -f "$secondFile" ] && [ -f "$thirdFile" ]; then

    bkpNewFolder="$kdenFilesPath"/bkp_"$(get_file_date)"
    mkdir "$bkpNewFolder"

    sysLogger i "\nCreating: $bkpNewFolder\n"

    sysLogger i "Copying into the $bkpNewFolder: 
    "$kdenFilesPath"/"$firstFile"  
    "$kdenFilesPath"/"$secondFile" 
    "$kdenFilesPath"/"$thirdFile"    
    \n\n"

    cp "$kdenFilesPath"/"$firstFile"    "$bkpNewFolder"
    cp "$kdenFilesPath"/"$secondFile"   "$bkpNewFolder"
    cp "$kdenFilesPath"/"$thirdFile"    "$bkpNewFolder"

    sysLogger i "Updating versions:
    "$kdenFilesPath"/"$firstFile"   "$kdenFilesPath"/"$secondFile"
    "$kdenFilesPath"/"$firstFile"   "$kdenFilesPath"/"$thirdFile"
    \n\n"

    cp "$kdenFilesPath"/"$firstFile"  "$kdenFilesPath"/"$secondFile"
    cp "$kdenFilesPath"/"$firstFile"  "$kdenFilesPath"/"$thirdFile"


#### If files doesn't exists, create them by copying from the origin
else 
    
    sysLogger w "\nFiles did not exist, copying...\n"
    cp "$kdenFilesPath"/"$firstFile" "$kdenFilesPath"/"$secondFile"
    cp "$kdenFilesPath"/"$firstFile" "$kdenFilesPath"/"$thirdFile"

    sysLogger i "Files created: 
        "$kdenFilesPath"/"$secondFile"
        "$kdenFilesPath"/"$thirdFile""   
fi


  

