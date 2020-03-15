#!/bin/bash

echo "using 32bit utils"

if ! [ -e ~/.makepkg.i686.conf ]; then
    echo "creating makepkg conf"

    echo 'CARCH="i686"' >>~/.makepkg.i686.conf
    echo 'CHOST="i686-unknown-linux-gnu"' >>~/.makepkg.i686.conf
    echo 'CFLAGS="-m32 -march=i686 -mtune=generic -O2 -pipe -fstack-protector-strong"' >>~/.makepkg.i686.conf
    echo 'CXXFLAGS="${CFLAGS}"' >>~/.makepkg.i686.conf
    echo 'LDFLAGS="-m32 -Wl,-O1,--sort-common,--as-needed,-z,relro"' >>~/.makepkg.i686.conf

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
