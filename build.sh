#!/bin/bash
############################################################
## build all instantos packages to recreate a full mirror ##
############################################################
echo "starting instantOS repo build"
# build functions
source utils.sh
if [ "$1" = "32" ]; then
    source utils32.sh
else
    rm makepkg.conf
fi

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash"
fi

for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then
        echo "building $i"
        bashbuild ${i#./}
    fi
done

# aur packages#
for i in $(cat aurpackages); do
    aurbuild "$i"
done
