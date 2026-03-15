#!/bin/bash

PROMPT="生成一份 AI 日报，3-5 条新闻，适合 Telegram 阅读。"

openclaw agent --agent main --message "$PROMPT"
