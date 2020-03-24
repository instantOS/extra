#!/bin/bash

#####################################################
## script to run after building instantos packages ##
#####################################################

cd ~/stuff/extra/build || exit 1

repo-add instant.db.tar.xz ./*.pkg.tar.xz
[ -e index.html ] && rm index.html
apindex . || echo "error: apindex not found" && exit
echo "done building repos"

if [ -e index.html ]; then
    if [ -z "$1" ]; then
        surge . instantos.surge.sh
    else
        surge . instantos32.surge.sh
    fi
else
    echo "repo build failed"
    exit 1
fi
