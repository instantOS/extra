#!/bin/bash

####################################################################
## get a full local copy of the repo without building it yourself ##
####################################################################

echo "pulling full repo"
curl -s instantos.surge.sh | grep -o '<a href=".*">' | grep -o '".*"' | grep -Eo '[^"]{3,}' >files.txt
for i in $(cat files.txt); do
    echo "downloading file $i"
    wget -q http://instantos.surge.sh/$i
done

wget -r http://instantos.surge.sh

rm files.txt
echo "done"
