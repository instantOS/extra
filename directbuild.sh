#!/bin/bash
echo "building instantOS repository"
cd
mkdir stuff &> /dev/null
cd stuff
rm -rf extra
git clone --depth=1 https://github.com/instantos/extra.git
cd extra
./build.sh
cd build

if [ -e index.html ]; then
    surge . instantos.surge.sh
else
    echo "repo build failed"
    exit 1
fi
