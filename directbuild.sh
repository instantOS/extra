#!/bin/bash
echo "building instantOS repository"
cd
cd stuff
rm -rf extra
git clone --depth=1 https://github.com/instantos/extra.git
cd extra
./build.sh
cd build
surge . instantos.surge.sh
