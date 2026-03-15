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
