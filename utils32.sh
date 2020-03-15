#!/bin/bash

echo "using 32bit utils"

if ! [ -e ~/.makepkg.i686.conf ]; then
    echo "creating makepkg conf"
    cat <<EOT >>~/.makepkg.i686.conf
'
CARCH="i686"
CHOST="i686-unknown-linux-gnu"
CFLAGS="-m32 -march=i686 -mtune=generic -O2 -pipe -fstack-protector-strong"
CXXFLAGS="${CFLAGS}"
LDFLAGS="-m32 -Wl,-O1,--sort-common,--as-needed,-z,relro"
'
EOT
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
