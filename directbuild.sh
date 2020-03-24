#!/bin/bash
echo "building instantOS repository"
cd
mkdir stuff &>/dev/null
cd stuff
rm -rf extra
git clone --depth=1 https://github.com/instantos/extra.git
cd extra

if [ -z "$1" ]; then
    ./build.sh
else
    ./build.sh "$1"
fi

./utils/postbuild.sh
