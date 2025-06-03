#!/bin/bash
# source: posh benchmark suite

set -euo pipefail

input="$1"
dest="$2"

mkdir -p "$dest"

for img in "$input"/*.jpg; do
    mogrify -format gif -path "$dest" -thumbnail 100x100 "$img" &
done

wait