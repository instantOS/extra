#!/bin/bash
THEMES="dracula
mac
arc
manjaro"

[ -e build ] && rm -rf build
mkdir build

buildclean() {
    if [ -e pkg ]; then
        rm -rf src
        rm -rf pkg
        rm -rf "$1*"
        rm -rf "*.pkg.tar.xz"
    fi
}

# build a simple bash script package
bashbuild() {
    [ -e "$1" ] || return
    cd "$1"
    makepkg
    mv *.pkg.tar.xz ../build/"$1".pkg.tar.xz
    cd ..
}

cd instantwm
for i in $THEMES; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantwm-$i.pkg.tar.xz
    buildclean 'instantwm-'
done
cd ..

cd instantmenu
for i in $THEMES; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantmenu-$i.pkg.tar.xz
    buildclean 'instantmenu-'
done
cd ..

cd instantlock
for i in $THEMES; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantlock-$i.pkg.tar.xz
    buildclean 'instantlock-'
done
cd ..

bashbuild instantassist
bashbuild instantwallpaper
bashbuild instantutils

cd build

if ! [ -e panther_launcher.pkg.tar.xz ]; then
    wget -q -O panther_launcher.pkg.tar.xz "https://www.rastersoft.com/descargas/panther_launcher/panther_launcher-1.12.0-1-x86_64.pkg.tar.xz"
fi

repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
