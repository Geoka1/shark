#!/bin/bash
# source: posh benchmark suite

shopt -s expand_aliases

alias g='git'
alias gst='git status'
alias gco='git checkout'
alias grs='git reset --hard'
alias gcl='git clean -fd'
alias gci='git commit'
alias gaa='git add -A'

TOP=$(git rev-parse --show-toplevel)
EVAL_DIR="${TOP}/repl"
REPO_PATH="${EVAL_DIR}/inputs/chromium"
COMMITS_DIR="${EVAL_DIR}/inputs/commits"
NUM_COMMITS="${1:-20}"

# override HOME variable
export HOME="$COMMITS_DIR"
mkdir -p "$COMMITS_DIR"

cd "$REPO_PATH" || exit 1

g config user.email "author@example.com"
g config user.name "A U Thor"

mapfile -t COMMITS < <(
  g rev-list --first-parent HEAD -n "$NUM_COMMITS" | tac
)
BASE_COMMIT=${COMMITS[0]}

g stash
gco main
g branch -D bench_branch "$BASE_COMMIT"
gco -b bench_branch 644ae58
grs
gcl

prev="$BASE_COMMIT"

for curr in "${COMMITS[@]:1}"; do
  if patch=$(g diff "$prev" "$curr"); [[ -n $patch ]]; then
    printf '%s\n' "$patch" | g apply -    
    g add -A                            
    g commit \
      --author="A U Thor <author@example.com>" \
      -m "$(g log -1 --pretty=%B "$curr")"   
  fi
  prev="$curr"
done
