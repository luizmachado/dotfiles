#!/usr/bin/env bash

CURDIR=$(pwd)
NOTE_FILE=$(mktemp --suffix=.md)
trap 'rm -f "$NOTE_FILE"' EXIT

nvim -c 'startinsert' "$NOTE_FILE"
RAW_NOTE="${1:-$(cat "$NOTE_FILE")}"

[[ -z "$RAW_NOTE" ]] && exit 1
cd "${PROJECTS_DIR}/notes" || exit 1

PROMPT=$(cat <<EOF
Read AGENTS.md in the current directory before doing anything else.
It contains all instructions for how to handle the note below.

Raw note:
${RAW_NOTE}

Current date: $(date "+%Y-%m-%dT%H:%M:%S")

Execute completely: write the file, commit, and push.
EOF
)

# codex exec "$PROMPT" --yolo
# gemini -y -p "$PROMPT"
claude --model opus -p "$PROMPT" --dangerously-skip-permissions

# This does not work in tmux popups
# nohup gemini -p "$PROMPT" -y > /dev/null 2>&1 < /dev/null &

cd "${CURDIR}" || exit 1
