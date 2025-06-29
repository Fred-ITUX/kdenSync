#!/bin/bash


#### SysInfo & path 
if [ -f ~/.bash_UT ]; then
    . ~/.bash_UT
fi


##############################################################################
#### general path
path="$HOME/Videos/Edit/Projects"

#### get the folder from fzf interactive selection
userChoice=$(ls "$path" | fzf --height=20% --border --prompt="Project > ")

#### Get the complete list of items in the project folder
fileList=$(ls "$path/$userChoice")


#### if no project selected
if [ -z "$userChoice" ]; then
    echo "No project selected. Exiting."
    exit 1
fi


kdenFolder="$userChoice/"$( echo -e "$fileList" | grep -i "kdenfiles" )

kdenFilesPath="$path/$kdenFolder"

echo -e "Kden Files Path: $kdenFilesPath\n"

cd "$kdenFilesPath"
##############################################################################






##############################################################################
echo -e "Choose the version to backup:"

#### Get the file from fzf interactive selection
firstFile=$(ls "$kdenFilesPath" | fzf --height=20% --border --prompt="File > ")

#### if no file selected
if [ -z "$firstFile" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

#### extension to check
ext=".kdenlive"

#### If matches, remove the .kdenlive
if [[ $firstFile == *"$ext" ]]; then
  base="${firstFile%"$ext"}"
else
  echo "❌ Filename doesn't end in $ext" >&2
  exit 1
fi

#### Pull off the trailing underscore + digits
if [[ $base =~ ^(.+)_([0-9]+)$ ]]; then

  prefix="${BASH_REMATCH[1]}"
  num="${BASH_REMATCH[2]}"

else
  echo "❌ No trailing _number found in $base" >&2
  exit 1
fi
##############################################################################






##############################################################################
#### Increment the version number ( ..._X.kdenlive )
secondNum=$(( num + 1 ))
thirdNum=$(( secondNum + 1 ))


secondFile="${prefix}_${secondNum}${ext}"
thirdFile="${prefix}_${thirdNum}${ext}"

if [ -f "$secondFile" ] && [ -f "$thirdFile" ]; then

  #### Files exists, proceed with update and backup
  bkpNewFolder="$kdenFilesPath"/bkp_"$(get_file_date)"
  mkdir "$bkpNewFolder"

  echo -e "\nCreating: $bkpNewFolder\n"

  echo -e "Copying into the $bkpNewFolder: 
  "$kdenFilesPath"/"$firstFile"  
  "$kdenFilesPath"/"$secondFile" 
  "$kdenFilesPath"/"$thirdFile"    
  \n\n"

  cp "$kdenFilesPath"/"$firstFile"    "$bkpNewFolder"
  cp "$kdenFilesPath"/"$secondFile"   "$bkpNewFolder"
  cp "$kdenFilesPath"/"$thirdFile"    "$bkpNewFolder"

  echo -e "Updating versions:
  "$kdenFilesPath"/"$firstFile"   "$kdenFilesPath"/"$secondFile"
  "$kdenFilesPath"/"$firstFile"   "$kdenFilesPath"/"$thirdFile"
  \n\n"

  cp "$kdenFilesPath"/"$firstFile"  "$kdenFilesPath"/"$secondFile"
  cp "$kdenFilesPath"/"$firstFile"  "$kdenFilesPath"/"$thirdFile"

##############################################################################
else
  #### If files doesn't exists, create them by copying from the origin
  echo -e "\nFiles do not exists, copying...\n"
  cp "$kdenFilesPath"/"$firstFile" "$kdenFilesPath"/"$secondFile"
  cp "$kdenFilesPath"/"$firstFile" "$kdenFilesPath"/"$thirdFile"

  echo -e "Files created: 
  "$kdenFilesPath"/"$secondFile"
  "$kdenFilesPath"/"$thirdFile""   
fi




