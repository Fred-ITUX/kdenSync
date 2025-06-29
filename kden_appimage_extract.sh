#!/bin/bash

#### Folder structure 
VideosPath="$HOME/Videos"

#### Top folders inside /Videos
mkdir "$VideosPath/Edit" "$VideosPath/OBS"

#### Kden dependencies
mkdir "$VideosPath/Edit/Kden" "$VideosPath/Edit/Kden/ProxyRender"

#### Projects folder
mkdir "$VideosPath/Edit/Projects"

#### Other kden dependencies
mkdir "$VideosPath/Edit/VideoRendering"


################################################################################################

#### Appimage extraction

kdenPath="$HOME/Videos/Edit/Kden"
file="$HOME/Nextcloud/Kden/Kdenlive/App/kdenlive-22.08.3b-x86_64.AppImage"

mkdir "$kdenPath"/kdenlive
cd "$kdenPath"/kdenlive

#### Copy the files folder with the GUI and kden settings
cp -r $HOME/Nextcloud/Kden/Kdenlive/kdenFiles "$kdenPath"

#### Extract the appimage
"$file" --appimage-extract

#### Make the apprun executable
sudo chmod +x "$kdenPath"/kdenlive/squashfs-root/AppRun


