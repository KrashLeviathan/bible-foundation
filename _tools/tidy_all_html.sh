#!/bin/bash

# This script goes through each folder in the directory recursively, finding
# html files and running tidy on them.

# Current directory
CDIR=$(pwd)

# Iterate through the directories recursively
for i in $(ls -R | grep :); do
    DIR=${i%:}                    # Strip ':'
    echo "cd $DIR"
    cd ${DIR}
    # Iterate through the html files in the directory
    for FILENAME in ./*.html; do
        # Tidy up the file (make it formatted pretty)
        tidy -i -m -q -w 120 -ashtml -utf8 "$FILENAME"
    done
    cd $CDIR
done
