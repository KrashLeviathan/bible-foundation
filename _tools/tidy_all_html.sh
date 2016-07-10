#!/bin/bash

# This script goes through each folder in the directory recursively, finding
# html files and running tidy on them.

# Current directory
CDIR=$(pwd)

# Colors for output
RED='\033[0;31m'
YEL='\033[1;33m'
NC='\033[0m' # No Color

# Iterate through the directories recursively
for i in $(ls -R | grep :); do
    DIR=${i%:}                    # Strip ':'
    cd ${DIR}

    ISEXCLUDED=`echo "$DIR" | grep "_posts" | wc -l`
    if [ $ISEXCLUDED != 0 ]
    then
        printf "${YEL}Excluding the _posts/ directory${NC}\n"
        cd $CDIR
        continue
    fi

    # If html files exist in the directory
    COUNT=`ls -1 *.html 2>/dev/null | wc -l`
    if [ $COUNT != 0 ]
    then
        printf "$DIR"
        # Iterate through the html files in the directory
        for FILENAME in ./*.html; do
            printf "    $FILENAME ${RED}\n"
            # Tidy up the file (make it formatted pretty)
            tidy -i -m -q -w 120 -ashtml -utf8 "$FILENAME"
            printf "$NC"
        done
    fi

    cd $CDIR
done
