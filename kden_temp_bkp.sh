#!/bin/bash


#### SysInfo & path 
if [ -f ~/.bash_UT ]; then
    . ~/.bash_UT
fi


#### path to send BKP
BKPath="/media/federico/SSD1TB/Projects/2-TempBKP"

#### general path
path="$HOME/Videos/Edit/Projects"



echo -e "Choose the project to backup:"

#### get the folder from fzf interactive selection
userChoice=$(ls "$path" | fzf --height=20% --border --prompt="Project > ")

#### if no project selected
if [ -z "$userChoice" ]; then
    echo "No project selected. Exiting."
    exit 1
fi


#### Get the complete list of items in the project folder
fileList=$(ls "$path/$userChoice")


#### KdenFiles folder
# kdenFolder="$path/$userChoice/2-KdenFiles"
kdenFolder="$path/$userChoice/"$( echo -e "$fileList" | grep -i "kdenfiles" )


##### Project ROBBBA
# robbbaFolder="$path/$userChoice/1-"$userChoice"_ROBBBA"
robbbaFolder="$path/$userChoice/"$(echo -e "$fileList" | grep -i "ROBBBA" )



#### create dynamic bkp folder
bkpFolder="$BKPath"/"$(get_file_date)"_"$userChoice"_BKP
mkdir "$bkpFolder"


cp -r "$kdenFolder" "$bkpFolder"
cp -r "$robbbaFolder" "$bkpFolder"


echo -e "\nFiles copied to $bkpFolder"
