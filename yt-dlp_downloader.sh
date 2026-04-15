#!/bin/bash
if [ -f "$HOME/.bash_UT"        ]; then . "$HOME/.bash_UT"       ; else echo -e "[CRITICAL ERROR] Bash module not found: $HOME/.bash_UT"       ; exit 1; fi

outputPath="$HOME/Downloads/YtVideos"

PlaylistOutputPath="$HOME/Downloads/YtVideos/Playlist" 

cookieFolder="$HOME/.mozilla/firefox/f61orgeg.default-release" #### Cookie folder --- thealldedfred

YT_DLP_updateLogPath="$HOME/Nextcloud/Kden/scripts/YT_DLP_update_log.txt"

urls="$HOME/Nextcloud/Kden/scripts/urls.txt"

# gedit "$urls" &
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



grabFileName(){
    lastModified=$(ls -t "$outputPath" | head -1)
    echo -e "$lastModified"
}


onComplete(){
    statusCheck+="\n  Completed: $(get_formatted_date)\nFilename: $(grabFileName)\n"
}

#########################################################################








#########################################################################



formats=(mp3 mp4) #### mkv -- case sensitive -- wav does not support quality control, always downloads BIG files (~20MB per min)

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
--js-runtime node
--extractor-args "youtube:player_client=android"
--paths "$PlaylistOutputPath"    
-o "%(title)s.%(ext)s"
-o "%(playlist_index)s - %(title)s.%(ext)s"
EOF

outputPath="$PlaylistOutputPath"


else
config=$(mktemp)
cat <<EOF > "$config"
--cookies-from-browser firefox:"$cookieFolder"
--js-runtime node
--extractor-args "youtube:player_client=android"
--paths "$outputPath"    
-o "%(title)s.%(ext)s"
EOF
fi


mkdir -p "$outputPath"


#########################################################################

statusCheck="\n    Starting: $(get_formatted_date)\n"

url="https://www.youtube.com/watch?v=k1PV5squdbY&t=47s"

if [ "$url" != "" ]; then

    # sysLogger i "🌐️ Refreshing ip\n"
    # nordvpn c italy
    # sleep 1s

    statusCheck+="\nDownloading: $url\n  Started: $(get_formatted_date)"


    if [ "$userChoice" == "mp4" ] || [ "$userChoice" == "mkv" ]; then
            yt-dlp --config-location "$config" \
            -f "bv*[height<=1080][fps<=60]+ba/b[height<=1080]" \
            --remux-video "$userChoice" \
            --embed-metadata \
            --embed-thumbnail \
            "$url"

        onComplete


    elif [ "$userChoice" == "mp3" ]; then
        yt-dlp --config-location "$config" \
            -f "ba/bestaudio" \
            -x \
            --audio-format mp3 \
            --audio-quality 0 \
            --embed-metadata \
            --embed-thumbnail \
            "$url"
        
        onComplete


    else
        statusCheck+="\n❌️ Error: no format / invalid format"
    fi

fi



statusCheck+="\n\n    ✅️ Done: $(get_formatted_date)\n" 
echo -e "$statusCheck" >> "$urls"

#### Extras
echo -e "$outputPath" | python3 "$HOME/Nextcloud/Python/scripts/FileModder/file_renamer.py"
echo -e "$outputPath" | python3 "$HOME/Nextcloud/Python/scripts/FileModder/mkv_converter.py"