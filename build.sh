#!/bin/bash
THEMES="dracula
mac
arc
manjaro"

mkdir build
cd instantwm

for i in "$THEMES"; do
    echo "$i" >/tmp/instanttheme
    makepkg .
    mv *.pkg.tar.xz ../build/instantwm-$i.pkg.tar.xz
    rm -rf instantwm-git
    rm -rf src
    rm -rf pkg
done
