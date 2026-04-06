#!/bin/bash

projectFolder="$HOME/Videos/Edit/Projects"

template="ProjectTemplate"

read -p "Project name: " projectName 

projectName=$(echo -e "$projectName" | tr ' ' _)


if [ -z "$projectName" ]; then echo -e "No name give, exiting"; exit 1; fi

robba="1-"$projectName"_ROBBBA"
kden="2-KdenFiles"
video="3-Video"
thumb="4-Thumbnail"
stream="5-Stream"
proxy="6-proxy"
parts="7-Parts"
extra="8-Extra"
effects="9-Effects"

txtFile="$projectName.txt"

path="$projectFolder/$projectName"

mkdir -p "$path"

mkdir "$path/$robba"
mkdir "$path/$kden"
mkdir "$path/$video"
mkdir "$path/$thumb"
mkdir "$path/$stream"
mkdir "$path/$proxy"
mkdir -p "$path/$parts/Pt1"
mkdir "$path/$extra"
mkdir "$path/$effects"


cat "$HOME/Nextcloud/Kden/Other/Docs/DescriptionUT.txt" > "$path/$txtFile" 

cp "$HOME/Nextcloud/Kden/Other/Templates/"$template".kdenlive" "$path/$kden/"$projectName"_1.kdenlive"