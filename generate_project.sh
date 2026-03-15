#!/bin/bash

mkdir -p scripts prompts tools config docs src/ai_daily_bot .github/workflows

cat << 'EOT' > README.md
# AI Daily Bot

AI Agent 自动生成 AI 日报并推送到 Telegram。

## Features

- 自动生成 AI 日报
- Telegram 推送
- cron 定时执行
- OpenClaw Agent 驱动

## Quick Start

git clone https://github.com/vitoi/ai-daily-bot.git

cd ai-daily-bot

./install.sh

export TELEGRAM_BOT_TOKEN=xxx
export TELEGRAM_CHAT_ID=xxx

./scripts/ai_daily_report.sh
EOT

cat << 'EOT' > install.sh
#!/bin/bash

echo "Installing AI Daily Bot..."

python3 -m venv .venv
source .venv/bin/activate
pip install feedparser requests pyyaml

chmod +x scripts/*.sh
echo "Done."
EOT

cat << 'EOT' > scripts/ai_daily_report.sh
#!/bin/bash

PROMPT="生成一份 AI 日报，3-5 条新闻，适合 Telegram 阅读。"

openclaw agent --agent main --message "$PROMPT"
EOT

cat << 'EOT' > prompts/ai_daily_prompt.md
生成 AI 日报：

要求：
1. 最近24小时AI新闻
2. 3-5条
3. 每条包含标题+摘要+影响
EOT

cat << 'EOT' > tools/telegram_send.json
{
"name":"telegram_send",
"description":"Send message to Telegram",
"parameters":{
"type":"object",
"properties":{
"text":{"type":"string"}
},
"required":["text"]
}
}
EOT

cat << 'EOT' > config/env.example
TELEGRAM_BOT_TOKEN=xxx
TELEGRAM_CHAT_ID=xxx
OPENCLAW_GATEWAY_TOKEN=123456
EOT

cat << 'EOT' > docs/architecture.md
Architecture

cron -> script -> openclaw agent -> telegram_send -> telegram
EOT

cat << 'EOT' > src/ai_daily_bot/collector.py
import feedparser

def collect(url):
    feed = feedparser.parse(url)
    for e in feed.entries[:5]:
        print(e.title)
EOT

cat << 'EOT' > .github/workflows/ci.yml
name: CI

on: [push]

jobs:
test:
runs-on: ubuntu-latest
steps:
- uses: actions/checkout@v3
EOT

echo "Project generated."
