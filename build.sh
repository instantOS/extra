#!/bin/bash

source utils.sh

themebuild instantwm
themebuild instantmenu
themebuild instantlock

bashbuild instantassist
bashbuild instantwallpaper
bashbuild instantutils
bashbuild autojump
bashbuild wmutils

cd build

if ! [ -e panther_launcher.pkg.tar.xz ]; then
    wget -q -O panther_launcher.pkg.tar.xz "https://www.rastersoft.com/descargas/panther_launcher/panther_launcher-1.12.0-1-x86_64.pkg.tar.xz"
fi

repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
