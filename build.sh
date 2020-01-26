#!/bin/bash
THEMES="dracula
mac
arc
manjaro"

[ -e build ] && rm -rf build
mkdir build

cd instantwm

if [ -e src ]; then
    rm -rf instantwm-git
    rm -rf src
    rm -rf pkg
    rm *.pkg.tar.xz
fi

for i in $THEMES; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantwm-$i.pkg.tar.xz
    rm -rf instantwm-git
    rm -rf src
    rm -rf pkg
done

cd ..

cd instantmenu

if [ -e src ]; then
    rm -rf instantmenu-*
    rm -rf src
    rm -rf pkg
    rm *.pkg.tar.xz
fi

for i in $THEMES; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantmenu-$i.pkg.tar.xz
    rm -rf instantmenu-*
    rm -rf src
    rm -rf pkg
done

cd ..

cd build
apindex .

repo-add instant.db.tar.xz ./*.pkg.tar.xz
