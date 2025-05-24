#!/bin/bash



                        ########################################
                        ####                                ####
                        ####        22.08.3B WAYLAND        ####
                        ####                                ####
                        ########################################



cd $HOME/Videos/Edit/Kden/App/
$HOME/Videos/Edit/Kden/App/kdenlive-22.08.3b-x86_64.AppImage --appimage-extract

#### Move the extracted AppImage folder to a permanent location (optional)
mkdir $HOME/Videos/Edit/Kden/kdenlive
mv $HOME/Videos/Edit/Kden/App/squashfs-root $HOME/Videos/Edit/Kden/kdenlive/






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
