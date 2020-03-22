#!/bin/bash
############################################################
## build all instantos packages to recreate a full mirror ##
############################################################
echo "starting instantOS repo build"
# build functions
source utils.sh
if [ "$1" = "32" ]; then
    source utils32.sh
else
    rm makepkg.conf
fi

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash and libwm-git"
fi

# themable instantOS packages
# need to be compiled
themebuild instantwm
themebuild instantmenu
themebuild instantlock

# third party packages not available in the default repos
# need to be compiled
bashbuild xdragon

# bashbuild grub-theme-live // not needed at the time

# instantOS exclusive packages
bashbuild instantdotfiles
bashbuild instantassist
bashbuild instantwallpaper
bashbuild instantutils
bashbuild instantthemes
bashbuild instantwidgets
bashbuild instantcursors
bashbuild instantshell
bashbuild instantconf
bashbuild instantwelcome

# paperbenni packages
bashbuild liveutils
bashbuild paperbash
bashbuild rangerplugins

# meta packages
bashbuild instantos
bashbuild instantdepend

# aur packages#
aurbuild otf-nerd-fonts-fira-code
aurbuild rofi-git
aurbuild libinput-gestures
aurbuild autojump
aurbuild urxvt-resize-font-git
aurbuild rxvt-unicode-pixbuf
aurbuild rofi-git

cd build


repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
echo "done building repos"
