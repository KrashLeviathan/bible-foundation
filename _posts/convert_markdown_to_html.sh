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

# Start the main blog page
BLOGFILE="$CDIR/../blog.html"
echo $(cat blog-page-begin.html) > ${BLOGFILE}

# Iterate through the directories recursively
for i in $(ls -R | grep :); do
    DIR=${i%:}                    # Strip ':'
    echo "cd $DIR"
    cd ${DIR}
    # Add the blog section title to the blog page
    BLOGSECTION=$(head -n 1 "./info.txt")
    BLOGSECTION=${BLOGSECTION: 7}
    echo "<h2>$BLOGSECTION</h2>" >> ${BLOGFILE}
    # Make an identical child folder in the target directory
    mkdir "$TDIR/$DIR"
    # Iterate through the markdown (.md) files in the directory
    for FILENAME in ./*.md; do
        BASENAME=$(basename "$FILENAME" .md)
        TARGETFILE="$TDIR/$DIR/$BASENAME.html"
        echo "    Converting $FILENAME"
        # Add the beginning parts of the html
        echo ${HTMLOPEN} > ${TARGETFILE}
        # Convert to html
        python -m markdown "$FILENAME" >> "$TARGETFILE"
        # Add the closing html
        echo ${HTMLCLOSE} >> ${TARGETFILE}
        # Tidy up the file (make it formatted pretty)
        tidy -i -m -q -w 120 -ashtml -utf8 "$TARGETFILE"
        # Update the blog page
        FIRSTLINE=$(head -n 1 ${FILENAME}) # First line of the markdown is the title
        TITLE=${FIRSTLINE:2}               # Strip the hash character off the front
        YEAR=${BASENAME:0:4}
        MONTH=${BASENAME:5:2}
        DAY=${BASENAME:8:2}
        echo "<p><a href='posts/$DIR/$(basename "$FILENAME" .md).html'>$TITLE</a><span class='post-date'>$MONTH.$DAY.$YEAR</span></p>" >> ${BLOGFILE}
    done
    cd $CDIR
done

# Close the main blog page and tidy it up
echo $(cat blog-page-end.html) >> ${BLOGFILE}
tidy -i -m -q -w 120 -ashtml -utf8 "$BLOGFILE"
