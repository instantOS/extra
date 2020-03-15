#!/bin/bash

echo "using 32bit utils"

if ! [ -e ~/.makepkg.i686.conf ]; then
    echo "creating makepkg conf"
    mv makepkg.conf ~/.makepkg.i686.conf
fi

# exit if failed build detected
checkmake() {
    echo "32bit build"
    if linux32 makepkg --config ~/.makepkg.i686.conf && ls *.pkg.tar.xz &>/dev/null; then
        echo "build successful"
    else
        echo "build failed at $(pwd)"
        exit 1
    fi

}
