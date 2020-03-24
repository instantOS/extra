#!/bin/bash

#####################################################
## utilities for building an instantOS repo mirror ##
#####################################################

THEMES="dracula
mac
arc
manjaro"

[ -e build ] && rm -rf build
mkdir build

# exit if failed build detected
checkmake() {
    remove already existing packages
    if ls | grep -q '\.pkg.\.tar\..{1,3}'; then
        rm *.pkg.tar.*
    fi

    if makepkg -C && ls *.pkg.tar.xz &>/dev/null; then
        echo "build successful"
    else
        echo "build failed at $(pwd)"
        exit 1
    fi

}

# remove all build files from directory
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
    echo "bashbuilding $1"
    [ -e "$1" ] || return
    cd "$1"

    checkmake

    if ls *.pkg.tar.xz | wc -l | grep -q '1'; then
        mv *.pkg.tar.xz ../build/"$1".pkg.tar.xz
    else
        mv *.pkg.tar.xz ../build/
    fi
    cd ..
}

# c programs using instantos theming
themebuild() {
    cd $1
    for i in $THEMES; do
        echo "$i" >/tmp/instanttheme
        checkmake
        mv *.pkg.tar.xz ../build/$1-$i.pkg.tar.xz
        buildclean "$1-"
    done
    cd ..
}

# build a program from the AUR
aurbuild() {
    git clone --depth=1 "https://aur.archlinux.org/$1.git" || return 1
    cd $1
    if [ -n "$2" ]; then
        sed -i 's/^pkgname=.*/pkgname='"$2"'/g' PKGBUILD
    fi
    checkmake
    if ls *.pkg.tar.xz | wc -l | grep -q '1'; then
        mv *.pkg.tar.xz ../build/"$1".pkg.tar.xz
    else
        mv *.pkg.tar.xz ../build/
    fi
    cd ..
    rm -rf $1
}

# put a binary from the web in the repo
linkbuild() {
    if ! $(pwd) | grep -q 'build'; then
        if [ -e build ]; then
            cd build
            TEMPBUILD="true"
        fi
    fi

    if ! [ -e $1.pkg.tar.xz ]; then
        wget -q -O $1.pkg.tar.xz "$2"
    fi

    if [ -n "$TEMPBUILD" ]; then
        unset TEMPBUILD
        cd ..
    fi
}
