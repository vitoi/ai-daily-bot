# AI Daily Bot

[![CI](https://github.com/YOUR_USERNAME/ai-daily-bot/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/ai-daily-bot/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)

基于 OpenClaw 的 AI 日报机器人：从多源抓取 AI 资讯 → LLM 摘要 → Telegram 推送。支持 YAML 配置数据源，无需改代码即可扩展。

---

## 目录

- [功能](#功能)
- [前置要求](#前置要求)
- [快速开始](#快速开始)
- [配置说明](#配置说明)
- [如何获取配置项](#如何获取配置项)
- [运行方式](#运行方式)
- [定时推送](#定时推送)
- [工作原理](#工作原理)
- [项目结构](#项目结构)
- [常见问题](#常见问题)
- [参与开发](#参与开发)
- [文档与许可](#文档与许可)

---

## 功能

| 功能 | 说明 |
|------|------|
| 每日 AI 摘要 | 多源 RSS + 链接聚合，由 LLM 生成摘要 |
| Telegram 推送 | 摘要发送到指定会话（群组/私聊） |
| 定时执行 | 使用 cron 设置每日自动运行 |
| 多源扩展 | `config/sources.yaml` 配置，增删源无需改代码 |

---

## 前置要求

| 项目 | 说明 |
|------|------|
| **Python 3.9+** | `python3 --version` 检查 |
| **OpenClaw** | 用于调用 LLM 做摘要（完整日报流程需要） |
| **Telegram Bot** | 创建 Bot 并获取 Token（推送需要） |
| **Telegram Chat ID** | 接收日报的会话 ID |

> 未安装 OpenClaw 时，仍可先运行 **「只测试采集」** 验证数据源与 Python 环境，见 [运行方式](#运行方式)。

---

## 快速开始

### 1. 克隆并安装

```bash
git clone https://github.com/YOUR_USERNAME/ai-daily-bot.git
cd ai-daily-bot
./install.sh
```

成功会输出 `Install complete.`，并生成 `.venv` 目录。

### 2. 配置环境变量

```bash
cp config/env.example .env
# 编辑 .env，填入下方「如何获取配置项」中的三个值
```

`.env` 格式（无引号、无多余空格）：

```bash
TELEGRAM_BOT_TOKEN=你的Bot_Token
TELEGRAM_CHAT_ID=你的Chat_ID
OPENCLAW_GATEWAY_TOKEN=你的OpenClaw_Token
```

### 3. 运行日报

```bash
source .venv/bin/activate
set -a && source .env && set +a   # 加载 .env（若失败见常见问题）
./scripts/ai_daily_report.sh
```

配置正确且 OpenClaw 可用时，脚本会跑完并可按你配置的方式推送；仅想验证采集时见 [只测试采集](#只测试采集)。

---

## 配置说明

| 变量 | 说明 |
|------|------|
| `TELEGRAM_BOT_TOKEN` | [@BotFather](https://t.me/BotFather) 创建的 Bot 的 API Token |
| `TELEGRAM_CHAT_ID` | 接收日报的会话 ID（私聊或群组） |
| `OPENCLAW_GATEWAY_TOKEN` | OpenClaw 网关认证 Token |

- **`.env`**：根目录，勿提交（已在 `.gitignore`）。
- **`config/sources.yaml`**：数据源（RSS、链接），按需增删。

---

## 如何获取配置项

**Telegram Bot Token**  
Telegram 搜 @BotFather → 发送 `/newbot` → 按提示起名 → 获得形如 `123456789:ABCdef...` 的 Token。

**Telegram Chat ID**  
1. 给 Bot 发一条消息（或把 Bot 拉进群并在群里发一条）。  
2. 浏览器打开：`https://api.telegram.org/bot<你的Token>/getUpdates`  
3. 在 JSON 中找 `"chat":{"id": 数字}`，即 Chat ID（群组多为负数）。

**OpenClaw Gateway Token**  
按你的 OpenClaw 部署方式，在文档或管理后台查看「网关认证 / API Token」。

---

## 运行方式

### 完整日报（需 OpenClaw + 正确 .env）

每次新开终端：

```bash
cd /path/to/ai-daily-bot
source .venv/bin/activate
set -a && source .env && set +a
./scripts/ai_daily_report.sh
```

### 只测试采集（不需 OpenClaw / Telegram）

仅验证数据源与 Python 环境，直接打印采集结果：

```bash
source .venv/bin/activate
PYTHONPATH=src python -m ai_daily_bot.runner
```

会从 `config/sources.yaml` 拉取 RSS 并输出格式化条目。

---

## 定时推送

每天 9:00 自动执行（将 `PATH_TO_PROJECT` 改为实际路径）：

```bash
crontab -e
```

添加一行：

```bash
0 9 * * * cd PATH_TO_PROJECT && . .venv/bin/activate && set -a && . .env && set +a && ./scripts/ai_daily_report.sh >> ~/ai_daily.log 2>&1
```

---

## 工作原理

1. 执行 `scripts/ai_daily_report.sh`（手动或 cron）
2. 脚本读取 `prompts/ai_daily_prompt.md`，调用 **OpenClaw Agent**
3. 结合 `config/sources.yaml` 与 `src/ai_daily_bot/` 采集 RSS 等
4. **LLM** 做摘要与整理
5. 通过 **Telegram Bot** 或 telegram_send 等发送

数据流：**配置与 Prompt → OpenClaw → 采集/摘要 → Telegram**

---

## 项目结构

```
ai-daily-bot/
├── config/
│   ├── env.example    # 复制为 .env 后填写
│   └── sources.yaml   # 数据源配置
├── prompts/           # 日报/周报提示词
├── scripts/
│   ├── ai_daily_report.sh
│   └── ai_weekly_report.sh
├── src/ai_daily_bot/  # 采集、格式化、runner
├── tools/             # 如 telegram_send 配置
├── docs/
├── tests/
├── install.sh
├── Makefile
└── README.md
```

---

## 常见问题

**没有 Python / `python3: command not found`？**  
安装 Python 3.9+（[python.org](https://www.python.org/downloads/) 或系统包管理器）。

**`./install.sh` 报 Permission denied？**  
执行 `chmod +x install.sh` 后再运行。

**加载 .env 报错或无效？**  
改用：`set -a && source .env && set +a`。或手动执行  
`export TELEGRAM_BOT_TOKEN=...`、`export TELEGRAM_CHAT_ID=...`、`export OPENCLAW_GATEWAY_TOKEN=...` 后再运行脚本。

**收不到 Telegram 消息？**  
确认：(1) Bot 已加入目标群或与用户有过私聊；(2) `.env` 中 Token 与 Chat ID 正确；(3) OpenClaw 或脚本中已配置「发送到 Telegram」。

**未装 OpenClaw，想先验证项目？**  
运行「只测试采集」：`source .venv/bin/activate && PYTHONPATH=src python -m ai_daily_bot.runner`，可验证数据源与采集逻辑。

更多见 [SUPPORT.md](SUPPORT.md) 或 [Issues](https://github.com/YOUR_USERNAME/ai-daily-bot/issues)。

---

## 参与开发

```bash
make install-dev   # 可编辑安装 + 开发依赖
make lint         # ruff 检查
make format       # ruff 格式化
make test         # 测试
make test-cov     # 测试 + 覆盖率
```

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。提交前建议 `make lint && make test`。

---

## 文档与许可

- [架构说明](docs/architecture.md) · [路线图](docs/roadmap.md) · [SECURITY.md](SECURITY.md)

[MIT](LICENSE)
