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

cd instantassist
makepkg
mv *.pkg.tar.xz ../build/instantassist.pkg.tar.xz
cd ..

cd instantwallpaper
makepkg
mv *.pkg.tar.xz ../build/instantwallpaper.pkg.tar.xz
cd ..

cd build
repo-add instant.db.tar.xz ./*.pkg.tar.xz
apindex .
