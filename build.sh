#!/bin/bash
############################################################
## build all instantos packages to recreate a full mirror ##
############################################################

# build functions
source utils.sh

themebuild instantwm
themebuild instantmenu
themebuild instantlock

bashbuild instantassist
bashbuild instantwallpaper
bashbuild instantutils
bashbuild xdragon
bashbuild grub-theme-live
bashbuild instantdotfiles
bashbuild liveutils
bashbuild paperbash
bashbuild instantthemes
bashbuild instantwidgets
bashbuild instantcursors

aurbuild wmutils-git wmutils
aurbuild libinput-gestures
aurbuild autojump
aurbuild libwm-git

cd build

linkbuild panther_launcher https://www.rastersoft.com/descargas/panther_launcher/panther_launcher-1.12.0-1-x86_64.pkg.tar.xz

repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
