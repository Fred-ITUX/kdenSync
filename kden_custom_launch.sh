#!/bin/bash


#### General paths
EXTRACTED_DIR="$HOME/Videos/Edit/Kden/kdenlive"  
SQUASHFS_ROOT="$EXTRACTED_DIR/squashfs-root"

kdenlivePath="$HOME/Videos/Edit/Kden"


#### XDG paths for Kdenlive’s data
export XDG_CONFIG_HOME="$kdenlivePath/kdenFiles/config"
export XDG_CACHE_HOME="$kdenlivePath/kdenFiles/cache"
export XDG_DATA_HOME="$kdenlivePath/kdenFiles/data"




#### MLT data for metadata manifests, mlt & melt engine
export MLT_DATA="$SQUASHFS_ROOT/usr/share/mlt-7"
export MLT_PATH="$SQUASHFS_ROOT/usr/lib/mlt-7"
export MLT_PROFILES="$SQUASHFS_ROOT/usr/share/mlt-7/profiles"
export LADSPA_PATH="$SQUASHFS_ROOT/usr/lib/ladspa"



#### Runtime
export PULSE_SERVER="unix:/run/user/$(id -u)/pulse/native"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"



#### Launch Kdenlive
gamemoderun "$SQUASHFS_ROOT/AppRun" "$@"



