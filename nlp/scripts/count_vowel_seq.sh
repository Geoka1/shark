#!/bin/bash

IN=${IN:-$SUITE_DIR/inputs/pg}
OUT=${1:-$SUITE_DIR/outputs/2_2/}
ENTRIES=${ENTRIES:-1000}
mkdir -p "$OUT"

# Parallelize the processing
for input in $(ls ${IN} | head -n ${ENTRIES} | xargs -I arg1 basename arg1); do
    tr 'a-z' '[A-Z]' < "$IN/$input" | tr -sc 'AEIOU' '[\012*]' | sort | uniq -c > "${OUT}/${input}.out" &
done

wait

echo 'done'

# rm -rf "$OUT"
