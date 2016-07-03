#!/bin/bash

# This script goes through each folder in the directory recursively, finding markdown
# files and converts them to html using `pything -m markdown input.md > output.html`
# The result is an identical file tree structure, with html file instead of markdown.

# Current directory
CDIR=$(pwd)

# The target directory is a sibling directory with the same name minus the underscore
TDIR="$CDIR/../posts"

# The <head> element for the html file
HTMLHEAD=`cat post-head.html`

# Body element tags
BODYOPEN="<body>"
BODYCLOSE="</body>"

# Iterate through the directories recursively
for i in $(ls -R | grep :); do
    DIR=${i%:}                    # Strip ':'
    echo "cd $DIR"
    cd ${DIR}
    # Make an identical child folder in the target directory
    mkdir "$TDIR/$DIR"
    # Iterate through the markdown (.md) files in the directory
    for FILENAME in ./*.md; do
        TARGETFILE="$TDIR/$DIR/$(basename "$FILENAME" .md).html"
        echo "    Converting $FILENAME"
        # Add the head and opening body tag
        echo ${HTMLHEAD} > ${TARGETFILE}
        echo ${BODYOPEN} >> ${TARGETFILE}
        # Convert to html
        python -m markdown "$FILENAME" >> "$TARGETFILE"
        # Add the closing html
        echo ${BODYCLOSE} >> ${TARGETFILE}
        # Tidy up the file (make it formatted pretty)
        tidy -i -m -q -w 120 -ashtml -utf8 "$TARGETFILE"
    done
    cd $CDIR
done
