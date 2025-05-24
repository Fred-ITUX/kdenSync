#!/bin/bash



                            #######################################
                            ####                               ####
                            ####        25.04.1 WAYLAND        ####
                            ####                               ####
                            #######################################






cd $HOME/Videos/Edit/Kden/App/
$HOME/Videos/Edit/Kden/App/kdenlive-25.04.1-x86_64.AppImage --appimage-extract
#### Move the extracted AppImage folder to a permanent location (optional)
mkdir $HOME/Videos/Edit/Kden/kdenlive
mv $HOME/Videos/Edit/Kden/App/squashfs-root $HOME/Videos/Edit/Kden/kdenlive/





# Define paths
# APPIMAGE="$HOME/Videos/Edit/Kden/App/kdenlive-25.04.1-x86_64.AppImage"
# EXTRACTED_DIR="$HOME/Videos/Edit/Kden/kdenlive"
# SQUASHFS_ROOT="$EXTRACTED_DIR/squashfs-root"


# echo "Extracting AppImage..."

# echo -e "mkdir"
# mkdir -p "$EXTRACTED_DIR"

# echo -e "Moving to $EXTRACTED_DIR"
# cd "$EXTRACTED_DIR" || exit 1
# "$APPIMAGE" --appimage-extract




######################################################################################
######################################################################################
######################################################################################

                            ####################################
                            ####                            ####
                            ####        22.08.3B X11        ####
                            ####                            ####
                            ####################################

#!/bin/bash


#### Extract the AppImage to a permanent location (outside /tmp)

# cd $HOME/Videos/Edit/Kden/App/
# $HOME/Videos/Edit/Kden/App/kdenlive-22.08.3b-x86_64.AppImage --appimage-extract
# #### Move the extracted AppImage folder to a permanent location (optional)
# mkdir $HOME/Videos/Edit/Kden/kdenlive
# mv $HOME/Videos/Edit/Kden/App/squashfs-root $HOME/Videos/Edit/Kden/kdenlive
