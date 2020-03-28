#!/bin/bash
############################################################
## build all instantos packages to recreate a full mirror ##
############################################################
echo "starting instantOS repo build"
# build functions
source utils.sh

if ! pacman -Qi paperbash &>/dev/null; then
    echo "please install paperbash"
fi

for i in ./*; do
    if [ -e "$i/PKGBUILD" ]; then
        if [ -e "$i"/ignore ] || [ -e ~/stuff/32bit/"$i" ]; then
            echo "package $i is ignored"
            continue
        fi
        echo "building $i"
        bashbuild ${i#./}
    fi
done

# aur packages#
for i in $(cat aurpackages); do
    if grep -q ':' <<<"$i"; then
        AURNAME=$(echo $i | grep -o '^[^:]*')
        AURFINALNAME=$(echo $i | grep -o '[^:]*$')
        aurbuild "$AURNAME" "$AURFINALNAME"
    else
        aurbuild "$i"
    fi
done
