#!/bin/bash
# source: posh benchmark suite

input="$1"
dest="$2"

mkdir -p "$dest"

for img in "$input"/*.jpg; do
    {
        filename=$(basename "$img" .jpg)
        convert "$img" -thumbnail 100x100 "$dest/${filename}.gif"
    } &
done

wait