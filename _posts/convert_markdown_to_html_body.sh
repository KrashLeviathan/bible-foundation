#!/bin/bash

# This script goes through each folder in the directory recursively, finding markdown
# files and converts them to html using `pything -m markdown input.md > output.html`
# The result is an identical file tree structure, with html file instead of markdown.

# Current directory
CDIR=$(pwd)

# The target directory is a sibling directory with the same name minus the underscore
TDIR="$CDIR/../posts"

# The opening and closing html elements for the post
HTMLOPEN=`cat post-begin.html`
HTMLCLOSE=`cat post-end.html`

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
        # Add the beginning parts of the html
        echo ${HTMLOPEN} > ${TARGETFILE}
        # Convert to html
        python -m markdown "$FILENAME" >> "$TARGETFILE"
        # Add the closing html
        echo ${HTMLCLOSE} >> ${TARGETFILE}
        # Tidy up the file (make it formatted pretty)
        tidy -i -m -q -w 120 -ashtml -utf8 "$TARGETFILE"
    done
    cd $CDIR
done
