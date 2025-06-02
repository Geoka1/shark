#!/bin/bash
# compress all files in a directory

mkdir -p "$2"

for item in "$1"/*; do
    output_name="$2/$(basename "$item").zip"
    gzip --no-name -c "$item" > "$output_name" &
done
wait

