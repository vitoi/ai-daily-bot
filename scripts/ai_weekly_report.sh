#!/bin/zsh
set -e

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
PROMPT_FILE="$ROOT_DIR/prompts/ai_weekly_prompt.md"

PROMPT=$(cat "$PROMPT_FILE")
openclaw agent --agent main --message "$PROMPT"
