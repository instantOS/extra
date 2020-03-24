#!/bin/bash

#############################################################
## build a single instantOS package and put it in the repo ##
#############################################################

[ -n "$1" ] || echo "usage: ./singlebuild.sh packagename" && exit

if ! [ -e ~/workspace/extra ]; then
    echo "downloading extra"
    mkdir ~/workspace
    cd ~/workspace
    git clone --depth=1 https://github.com/instantos/extra
fi

cd ~/workspace/extra

git pull || exit

if ! [ -e "$1/PKGBUILD" ]; then
    echo "no $1 is not a package"
    exit
fi

# get a full copy of the repo working first
if ! [ -e ~/stuff/extra/build ]; then
    mkdir -p ~/stuff/extra/build
    cd ~/stuff/extra/build
    source ~/workspace/extra/utils/fetchrepo.sh
fi

cd ~/stuff/extra/build
if [ -e "$1".* ]; then
    echo "removing previous version"
    rm "$1".*
fi

mkdir -p ~/.cache/instantos/pkg
cd ~/.cache/instantos/pkg
cp ~/workspace/extra/$1/* .
makepkg

mv *.pkg.tar.xz ~/stuff/extra/build/"$1".pkg.tar.xz
~/workspace/extra/utils/postbuild.sh
echo "done building $1"
