#!/bin/bash


#### SysInfo & path 
if [ -f ~/.bash_UT ]; then
    . ~/.bash_UT
fi



#########################################################################

#### Path
outputPath="$HOME/Downloads"

#### Fixed path for playlists
PlaylistOutputPath="$HOME/Downloads/Playlist"

#### Cookie folder --- thealldedfred
cookieFolder="$HOME/.mozilla/firefox/45ym995r.default-release"

#### Update log
YT_DLP_updateLogPath="$HOME/Nextcloud/Kden/scripts/YT_DLP_update_log.txt"

#########################################################################







#########################################################################

#### Update check -- Don't re-run the update if already checked the same day

alreadyUpdated=$(cat $HOME/Nextcloud/Kden/scripts/YT_DLP_update_log.txt | grep "$(get_date_comparison)")

# echo -e "UnixDateComparison: $UnixDateComparison"

# echo -e "alreadyUpdated: $alreadyUpdated"

#### If the date is not present in the log, run the update check
if [ "$alreadyUpdated" = ""  ]; then

    echo -e "\nChecking for updates...\n"

   {   
    get_sys_Info

    # echo -e "\n    • yt-dlp -U update:"
    # yt-dlp -U

    echo -e "\n    • Pipx yt-dlp upgrade:"
    pipx upgrade yt-dlp

    } >> "$YT_DLP_updateLogPath"
    echo -e "\nUpdate check done\n"
fi

#########################################################################







#########################################################################

####                CASE SENSITIVE FORMATS
#### wav does not support quality control, always downloads BIG files (~20MB per min)

#audioFormat="wav"
audioFormat="mp3"

#videoFormat="mp4"
videoFormat="mkv"


#### User inputs
echo -e "Format:"
read -p "1. $videoFormat   2. $audioFormat : " userChoice
read -p "URL: " url
read -p "Playlist? y/n: " playlist



####                            Config file

#### Enumerate items for playlists
if [ "$playlist" == "y" ]; then
config=$(mktemp)
cat <<EOF > "$config"
--cookies-from-browser firefox:"$cookieFolder"
--paths "$PlaylistOutputPath"    
-o "%(title)s.%(ext)s"
-o "%(playlist_index)s - %(title)s.%(ext)s"
EOF
#### If not a playlist, leave the file name as is
else
config=$(mktemp)
cat <<EOF > "$config"
--cookies-from-browser firefox:"$cookieFolder"
--paths "$outputPath"    
-o "%(title)s.%(ext)s"
EOF
fi

#########################################################################


#### ip change
echo -e "\nRefreshing ip\n"
nordvpn connect Italy

sleep 1s
echo -e "\nDownloading... \n"




#### Other function to work with downloaded videos (if merge doesn't work)
#--recode-video "$videoFormat" \

#### Per 1440 2K 
# -f "bestvideo[height<=1440][fps<=60]+bestaudio/best" \

#########################################################################
if [ "$userChoice" = "1" ]; then
   yt-dlp --config-location "$config" \
           -f "bestvideo[height<=1080][fps<=60]+bestaudio/best" \
           --merge-output-format "$videoFormat" \
           "$url"
#########################################################################
elif [ "$userChoice" = "2" ]; then
    yt-dlp --config-location "$config" \
        -f bestaudio \
        --extract-audio \
        --audio-format "$audioFormat" \
        --audio-quality 256k \
        "$url"
#########################################################################
else
    echo -e "No format / invalid format"
    exit 1
fi

