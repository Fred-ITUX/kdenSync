#!/bin/bash

#### General paths
EXTRACTED_DIR="$HOME/Videos/Edit/Kden/kdenlive"  
SQUASHFS_ROOT="$EXTRACTED_DIR/squashfs-root"
kdenlivePath="$HOME/Videos/Edit/Kden"


#### XDG paths for Kdenlive’s data
export XDG_CONFIG_HOME="$kdenlivePath/kdenFiles/config"
export XDG_CACHE_HOME="$kdenlivePath/kdenFiles/cache"
export XDG_DATA_HOME="$kdenlivePath/kdenFiles/data"


#### Fix ALSA / AppImage runtime paths
export LD_LIBRARY_PATH=""
export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libasound.so.2"



#### MLT data for metadata manifests, mlt & melt engine
export MLT_DATA="$SQUASHFS_ROOT/usr/share/mlt-7"
export MLT_PATH="$SQUASHFS_ROOT/usr/lib/mlt-7"
export MLT_PROFILES="$SQUASHFS_ROOT/usr/share/mlt-7/profiles"
export LADSPA_PATH="$SQUASHFS_ROOT/usr/lib/ladspa"



#### Force-enable VA-API for AMD and
export LIBVA_DRIVER_NAME=radeonsi
export LIBVA_DRIVERS_PATH="/usr/lib/x86_64-linux-gnu/dri"
export LIBVA_MESSAGING_LEVEL=1
export MESA_VAAPI_DEVICE="/dev/dri/renderD128"
export KDENLIVE_FFMPEG="/usr/bin/ffmpeg"
export KDENLIVE_FFPLAY="/usr/bin/ffplay"
export KDENLIVE_FFPROBE="/usr/bin/ffprobe"
export KDENLIVE_MELT="/usr/bin/melt"



#### Runtime
export PULSE_SERVER="unix:/run/user/$(id -u)/pulse/native"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"


#### Launch Kdenlive (with GameMode)
gamemoderun "$SQUASHFS_ROOT/AppRun" "$@"
