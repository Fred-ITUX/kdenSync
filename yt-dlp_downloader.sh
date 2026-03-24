#!/bin/bash


#### SysInfo & path 
if [ -f ~/.bash_UT ]; then
    . ~/.bash_UT
fi


#########################################################################

outputPath="$HOME/Downloads/YtVideos"

PlaylistOutputPath="$HOME/Downloads/YtVideos/Playlist" 

cookieFolder="$HOME/.mozilla/firefox/45ym995r.default-release" #### Cookie folder --- thealldedfred

YT_DLP_updateLogPath="$HOME/Nextcloud/Kden/scripts/YT_DLP_update_log.txt"

urls="$HOME/Nextcloud/Kden/scripts/urls.txt"

gedit "$urls" &

#########################################################################




#########################################################################

alreadyUpdated=$( grep -F "$(get_date_comparison)" "$HOME/Nextcloud/Kden/scripts/YT_DLP_update_log.txt" )

if [ -z "$alreadyUpdated" ]; then

    echo -e "\nChecking for updates...\n"
   {   
    get_sys_Info

    echo -e "\n    • yt-dlp -U update:"
    yt-dlp -U

    echo -e "\n    • Pipx yt-dlp upgrade:"
    pipx upgrade yt-dlp

    } >> "$YT_DLP_updateLogPath"
    echo -e "\nUpdate check done\n"
fi


log_file_empty=$(cat "$urls")
log_file_used=$(cat "$urls" | grep "✅️")

if [ -z "$log_file_empty" ] || [ "$log_file_used" != "" ]  ; then
   echo -e "❌️ File $urls empty or used, exiting\n...\n$(less $urls)"
   exit 1
fi


grabFileName(){
    lastModified=$(ls -t "$outputPath" | head -1)
    echo -e "$lastModified"
}


onComplete(){
    statusCheck+="\n  Completed: $(get_formatted_date)\nFilename: $(grabFileName)\n"
}

#########################################################################








#########################################################################



formats=(mkv mp3 mp4) #### case sensitive -- wav does not support quality control, always downloads BIG files (~20MB per min)

userChoice=$(printf "%s\n" "${formats[@]}" | fzf --height=1% --border --prompt="Format > ")

checkPlaylist=(No Yes)
playlist=$(printf "%s\n" "${checkPlaylist[@]}" | fzf --height=1% --border --prompt="Playlist? > ")


echo -e "\nFormat: $userChoice\nPlaylist: $playlist\n"


####                            Config file

#### Enumerate items for playlists
if [ "$playlist" == "Yes" ]; then

config=$(mktemp)
cat <<EOF > "$config"
--cookies-from-browser firefox:"$cookieFolder"
--paths "$PlaylistOutputPath"    
-o "%(title)s.%(ext)s"
-o "%(playlist_index)s - %(title)s.%(ext)s"
EOF

outputPath="$PlaylistOutputPath"


else
config=$(mktemp)
cat <<EOF > "$config"
--cookies-from-browser firefox:"$cookieFolder"
--paths "$outputPath"    
-o "%(title)s.%(ext)s"
EOF
fi


mkdir -p "$outputPath"


#########################################################################

statusCheck="\n    Starting: $(get_formatted_date)\n"

while IFS= read -r line; do
    
    url="$line"

    if [ "$url" != "" ]; then
    
        echo -e "\n🌐️ Refreshing ip\n"
        nordvpn connect italy
        sleep 1s

        statusCheck+="\nDownloading: $url\n  Started: $(get_formatted_date)"

        #### Per 1440 2K 
        # -f "bestvideo[height<=1440][fps<=60]+bestaudio/best" \

        #########################################################################
        if [ "$userChoice" == "mp4" ] || [ "$userChoice" == "mkv" ]; then
            yt-dlp --config-location "$config" \
                -f "bestvideo[height<=1080][fps<=60]+bestaudio/best" \
                --merge-output-format "$userChoice" \
                "$url"

            onComplete
        #########################################################################
        elif [ "$userChoice" == "mp3" ]; then
            yt-dlp --config-location "$config" \
                -f bestaudio \
                --extract-audio \
                --audio-format "$userChoice" \
                --audio-quality 256k \
                "$url"
            
            onComplete
        #########################################################################
        else
            statusCheck+="\n❌️ Error: no format / invalid format"
        fi

    fi


done < "$urls"

statusCheck+="\n\n    ✅️ Done: $(get_formatted_date)\n" 
echo -e "$statusCheck" >> "$urls"

#### Extras
echo -e "$outputPath" | python3 "$HOME/Nextcloud/Python/scripts/FileModder/file_renamer.py"
echo -e "$outputPath" | python3 "$HOME/Nextcloud/Python/scripts/FileModder/mkv_converter.py"