#!/usr/bin/env bash
# usage:  song-playlists.sh <input-root> <output-root>


IN=$1
OUT=$2
mkdir -p "$OUT"

MAX_JOBS=${MAX_JOBS:-$(nproc)}
jobs_running=0

for dir_path in "$IN"/*; do
  [[ -d $dir_path ]] || continue
  (
    dir=$(basename "$dir_path")
    echo "Processing directory: $dir"

    files=$(find "$dir_path" -type f -name '*.mp3' | sort)
    num_files=$(printf '%s\n' "$files" | wc -l)

    abs_prefix=$(realpath "$dir_path")
    llm embed-multi -m clap songs \
        --binary --files "$abs_prefix" '*.mp3' --prefix "$abs_prefix/"

    first_song=$(printf '%s\n' "$files" | head -n1)
    last_song=$(printf '%s\n'  "$files" | tail -n1)

    mkdir -p "$OUT/$dir"
    playlist_path="$OUT/$dir/playlist.m3u"

    llm interpolate songs "$first_song" "$last_song" -n "$num_files" \
        | jq .[] > "$playlist_path"
  ) &                                   # ── background worker

  ((jobs_running++))
  if (( jobs_running >= MAX_JOBS )); then
    wait -n                             # free one slot
    ((jobs_running--))
  fi
done

wait                                     # wait for all directory jobs
