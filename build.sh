#!/bin/bash
############################################################
## build all instantos packages to recreate a full mirror ##
############################################################
echo "starting instantOS repo build"
# build functions
source utils.sh

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash and libwm-git"
fi

# themable instantOS packages
themebuild instantwm
themebuild instantmenu
themebuild instantlock

# third party packages not available in the default repos
bashbuild xdragon
# bashbuild grub-theme-live // not needed at the time
bashbuild instantdotfiles
bashbuild liveutils
bashbuild paperbash
bashbuild rangerplugins

# instantOS exclusive packages
bashbuild instantassist
bashbuild instantwallpaper
bashbuild instantutils
bashbuild instantthemes
bashbuild instantwidgets
bashbuild instantcursors
bashbuild instantshell
bashbuild instantfonts
bashbuild instantconf
bashbuild instantwelcome

# meta packages
bashbuild instantos
bashbuild instantdepend

# aur packages
aurbuild libwm-git
aurbuild wmutils-git wmutils
aurbuild libinput-gestures
aurbuild autojump
aurbuild urxvt-resize-font-git
aurbuild rxvt-unicode-pixbuf

cd build

# linkbuild panther_launcher https://www.rastersoft.com/descargas/panther_launcher/panther_launcher-1.12.0-1-x86_64.pkg.tar.xz

repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
echo "done building repos"
