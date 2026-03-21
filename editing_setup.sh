#!/bin/bash


#### Folder structure 
VideosPath="$HOME/Videos"
kdenPath="$HOME/Videos/Edit/Kden"

if [ -d "$kdenPath" ]; then
   echo -e "The folder "$kdenPath" already exist"
   exit 1
fi


mkdir -p "$VideosPath/OBS" "$VideosPath/Edit/VideoRendering" "$VideosPath/Edit/Projects" "$VideosPath/Edit/Kden" "$VideosPath/Edit/Kden/ProxyRender"


#### Appimage extraction

file="$HOME/Nextcloud/Kden/Kdenlive/App/kdenlive-22.08.3b-x86_64.AppImage"

if [ ! -f "$file" ]; then
   echo -e "The file "$file" does not exist"
   exit 1
fi

mkdir -p "$kdenPath"/kdenlive
cd "$kdenPath"/kdenlive

#### Copy the files folder with the GUI and kden settings
cp -r "$HOME/Nextcloud/Kden/Kdenlive/kdenFiles" "$kdenPath"

#### Extract the appimage
sudo chmod +x "$file"
"$file" --appimage-extract

sudo chmod +x "$kdenPath"/kdenlive/squashfs-root/AppRun