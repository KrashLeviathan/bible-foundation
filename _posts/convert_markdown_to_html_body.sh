#!/bin/bash
for filename in ./*.md; do
    python -m markdown $filename > ./html_bodies/$(basename "$filename" .md).html
done
