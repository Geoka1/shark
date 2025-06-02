#!/usr/bin/env bash
# usage:  img-titles.sh <input-dir> <output-dir>


IN=$1
OUT=$2
mkdir -p "$OUT"

MAX_JOBS=${MAX_JOBS:-$(nproc)}   # cap simultaneous llm invocations
jobs_running=0

ollama serve   > ollama_serve.log 2>&1 &
ollama_srv_pid=$!

ollama pull gemma3

find "$IN" -type f -iname '*.jpg' | while IFS= read -r img; do
  {
    title=$(llm -m gemma3 \
        "Your only output should be a **single** small title for this image:" \
        -a "$img" -o seed 0 -o temperature 0 < /dev/null)

    base=$(echo "$title" | tr '[:upper:]' '[:lower:]' \
           | sed 's/ /_/g; s/[^a-z0-9_-]//g')
    filename="${base}.jpg"
    count=1
    while [[ -e "$OUT/$filename" ]]; do
      filename="${base}_$count.jpg"
      count=$((count+1))
    done
    cp "$img" "$OUT/$filename"
  } &                                  # ── background worker

  ((jobs_running++))
  if (( jobs_running >= MAX_JOBS )); then
    wait -n                            # free one slot
    ((jobs_running--))
  fi
done

wait                                   # wait for all workers
kill "$ollama_srv_pid"
