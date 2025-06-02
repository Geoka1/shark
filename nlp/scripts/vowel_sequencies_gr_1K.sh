#!/bin/bash
# tag: vowel_sequences_gr_1K.sh
# set -euo pipefail

IN=${IN:-"$SUITE_DIR/inputs/pg"}
OUT=${1:-"$SUITE_DIR/outputs/8.2_1/"}
ENTRIES=${ENTRIES:-1000}
mkdir -p "$OUT"

for input in $(ls "$IN" | head -n "$ENTRIES" | xargs -I arg1 basename arg1); do
{
    tr -c 'A-Za-z' '[\n*]' < "$IN/$input" |
    grep -v "^\s*$" |
    tr -sc 'AEIOUaeiou' '[\012*]' |
    sort |
    uniq -c |
    awk '$1 >= 1000' > "$OUT/${input}.out"
} &
done

wait
echo 'done'
