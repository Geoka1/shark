#!/bin/bash
# tag: four-letter words
# set -e

# the original script has both versions
IN=${IN:-$SUITE_DIR/inputs/pg}
OUT=${1:-$SUITE_DIR/outputs/6_2/}
ENTRIES=${ENTRIES:-1000}
mkdir -p "$OUT"


for input in $(ls ${IN} | head -n ${ENTRIES} | xargs -I arg1 basename arg1); do
    tr -c 'A-Za-z' '[\n*]' < "$IN/$input" | grep -v "^\s*$" | grep -c '^....$' > "${OUT}/${input}.out0" &
    tr -c 'A-Za-z' '[\n*]' < "$IN/$input" | grep -v "^\s*$" | sort -u | grep -c '^....$' > "${OUT}/${input}.out1" &
done
wait

echo 'done';
# rm -rf "$OUT"
