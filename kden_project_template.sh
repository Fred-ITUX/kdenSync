#!/bin/bash


projectFolder="$HOME/Videos/Edit/Projects"

#### kden template
template="ProjectTemplate"

# echo -e "Using template: $template"

read -p "Project name: " projectName

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

mkdir $path

mkdir $path/$robba
mkdir $path/$kden
mkdir $path/$video
mkdir $path/$thumb
mkdir $path/$stream
mkdir $path/$proxy
mkdir $path/$parts
mkdir $path/$parts/Pt1
mkdir $path/$extra
mkdir $path/$effects

#### Create txt file from UT template
touch $path/$txtFile

cat $HOME/Nextcloud/Kden/Other/Docs/DescriptionUT.txt > $path/$txtFile 


#### Copy template
cp $HOME/Nextcloud/Kden/Other/Templates/"$template".kdenlive $path/$kden/"$projectName"_1.kdenlive

