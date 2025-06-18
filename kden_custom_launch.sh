#!/bin/bash


                        ########################################
                        ####                                ####
                        ####        22.08.3B WAYLAND        ####
                        ####                                ####
                        ########################################

                        
#######################################
####        NEXTCLOUD SETUP        ####
#######################################

#### Paths
# EXTRACTED_DIR="$HOME/Videos/Edit/Kden/kdenlive"  
# SQUASHFS_ROOT="$EXTRACTED_DIR/squashfs-root"
EXTRACTED_DIR="$HOME/Nextcloud/Kden/Kdenlive/kdenlive"
SQUASHFS_ROOT="$HOME/Nextcloud/Kden/Kdenlive/kdenlive/squashfs-root"

kdenlivePath="$HOME/Nextcloud/Kden/Kdenlive"


#### XDG paths for Kdenlive’s data
# export XDG_CONFIG_HOME="$HOME/Videos/Edit/Kden/kdenFiles/config"
export XDG_CONFIG_HOME="$kdenlivePath/kdenFiles/config"

# export XDG_CACHE_HOME="$HOME/Videos/Edit/Kden/kdenFiles/cache"
export XDG_CACHE_HOME="$kdenlivePath/kdenFiles/cache"


# export XDG_DATA_HOME="$HOME/Videos/Edit/Kden/kdenFiles/data"
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












######################################################################################
######################################################################################
######################################################################################



                            ####################################
                            ####                            ####
                            ####        22.08.3B X11        ####
                            ####                            ####
                            ####################################

#!/bin/bash


# #### XDG paths for Kdenlive’s data
# export XDG_CONFIG_HOME=$HOME/Videos/Edit/Kden/kdenFiles/config
# export XDG_CACHE_HOME=$HOME/Videos/Edit/Kden/kdenFiles/cache
# export XDG_DATA_HOME=$HOME/Videos/Edit/Kden/kdenFiles/data

# #### MLT data for metadata manifests
# export MLT_DATA=$HOME/Videos/Edit/Kden/kdenlive/squashfs-root/usr/share/mlt-7

# #### Audio fix via Pulse
# export PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native

# #### Runtime & D-Bus
# export XDG_RUNTIME_DIR=/run/user/$(id -u)

# export LADSPA_PATH="$HOME/Videos/Edit/Kden/kdenlive/squashfs-root/usr/lib/ladspa"
# export MLT_PATH="$HOME/Videos/Edit/Kden/kdenlive/squashfs-root/usr/lib/mlt-7"
# export MLT_PROFILES="$HOME/Videos/Edit/Kden/kdenlive/squashfs-root/usr/share/mlt-7/profiles"


# #### direct appimage
# # $HOME/Videos/Edit/Kden/App/kdenlive-22.08.3b-x86_64.AppImage "$@"
# #gamemoderun $HOME/Videos/Edit/Kden/App/kdenlive-22.08.3b-x86_64.AppImage "$@"

# #### extracted appimage
# # $HOME/Videos/Edit/Kden/kdenlive/squashfs-root/AppRun "$@"
# gamemoderun $HOME/Videos/Edit/Kden/kdenlive/squashfs-root/AppRun "$@"

