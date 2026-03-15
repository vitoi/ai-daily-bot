# AI Daily Bot

[![CI](https://github.com/YOUR_USERNAME/ai-daily-bot/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/ai-daily-bot/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)

基于 OpenClaw 的 AI 日报机器人：自动抓取多源 AI 资讯，经 LLM 摘要后通过 Telegram 推送。

---

## 目录

- [功能简介](#功能简介)
- [前置要求](#前置要求)
- [新手部署（三步走）](#新手部署三步走)
- [配置说明](#配置说明)
- [如何获取配置项](#如何获取配置项)
- [运行与验证](#运行与验证)
- [定时推送（可选）](#定时推送可选)
- [工作原理简述](#工作原理简述)
- [项目结构](#项目结构)
- [常见问题](#常见问题)
- [参与开发](#参与开发)
- [文档与许可](#文档与许可)

---

## 功能简介

| 功能 | 说明 |
|------|------|
| 每日 AI 摘要 | 从多个 RSS 与链接聚合 AI 资讯，由 LLM 生成摘要 |
| Telegram 推送 | 将摘要发送到指定 Telegram 会话 |
| 定时执行 | 可用 cron 设置每天固定时间自动运行 |
| 多源扩展 | 通过 YAML 配置数据源，无需改代码即可增删 |

---

## 前置要求

部署前请确认本机已具备：

| 项目 | 说明 |
|------|------|
| **Python 3.9+** | 终端执行 `python3 --version` 检查 |
| **OpenClaw** | 已安装并可用（用于调用 LLM 做摘要） |
| **Telegram Bot** | 在 Telegram 创建 Bot 并拿到 Token |
| **Telegram Chat ID** | 要接收日报的会话（群组或私聊）的 ID |

> 若尚未安装 OpenClaw 或未创建 Telegram Bot，可先看下文 [如何获取配置项](#如何获取配置项)。

---

## 新手部署（三步走）

### 第一步：克隆并安装

```bash
# 克隆仓库（将 YOUR_USERNAME 换成实际 GitHub 用户名或组织名）
git clone https://github.com/YOUR_USERNAME/ai-daily-bot.git
cd ai-daily-bot

# 一键安装：创建虚拟环境并安装依赖
./install.sh
```

安装成功会看到 `Install complete.`，项目下会多出 `.venv` 目录。

### 第二步：填写配置

```bash
# 复制环境变量示例文件
cp config/env.example .env

# 用任意编辑器打开 .env，填入你的密钥（见下方「如何获取配置项」）
# 例如：nano .env  或  open .env
```

`.env` 中需要填写这三项（不要加引号、不要留空格）：

```bash
TELEGRAM_BOT_TOKEN=你的Bot的Token
TELEGRAM_CHAT_ID=你的会话ID
OPENCLAW_GATEWAY_TOKEN=你的OpenClaw网关Token
```

### 第三步：运行日报脚本

```bash
# 激活虚拟环境（每次新开终端都要执行一次）
source .venv/bin/activate

# 加载 .env 中的环境变量
export $(grep -v '^#' .env | xargs)

# 执行日报（会调用 OpenClaw 生成摘要并可按你配置的方式推送）
./scripts/ai_daily_report.sh
```

若配置正确，脚本会正常跑完；若希望发到 Telegram，需在 OpenClaw 或本项目中配置好发送逻辑（如使用 `telegram_send` 等）。

---

## 配置说明

| 变量名 | 必填 | 说明 |
|--------|------|------|
| `TELEGRAM_BOT_TOKEN` | 是 | 由 [@BotFather](https://t.me/BotFather) 创建的 Bot 的 API Token |
| `TELEGRAM_CHAT_ID` | 是 | 接收日报的会话 ID（私聊或群组） |
| `OPENCLAW_GATEWAY_TOKEN` | 是 | OpenClaw 网关认证用的 Token |

- 配置文件路径：项目根目录下的 **`.env`**（不要提交到 Git，已在 `.gitignore` 中）。
- 数据源配置：**`config/sources.yaml`**，可在此增删 RSS 地址和自定义链接，无需改代码。

---

## 如何获取配置项

### 1. Telegram Bot Token

1. 在 Telegram 中搜索 **@BotFather**。
2. 发送 `/newbot`，按提示起名、设置用户名。
3. 创建成功后，BotFather 会发给你一串 **Token**，形如 `123456789:ABCdefGHI...`，复制到 `.env` 的 `TELEGRAM_BOT_TOKEN`。

### 2. Telegram Chat ID

- **私聊**：先给你的 Bot 发一条任意消息，然后访问  
  `https://api.telegram.org/bot<你的BotToken>/getUpdates`  
  在返回的 JSON 里找到 `"chat":{"id": 数字}`，该数字即为 Chat ID。
- **群组**：把 Bot 拉进群，在群里发一条消息，同样用上面链接查看返回中的 `chat.id`（群组 ID 通常为负数）。

将得到的数字填到 `.env` 的 `TELEGRAM_CHAT_ID`。

### 3. OpenClaw Gateway Token

根据你使用的 OpenClaw 部署方式，在 OpenClaw 文档或管理后台中查看「网关认证」或「API Token」，将得到的值填到 `.env` 的 `OPENCLAW_GATEWAY_TOKEN`。

---

## 运行与验证

**每次运行前**（在新终端中）：

```bash
cd /path/to/ai-daily-bot    # 进入项目目录
source .venv/bin/activate   # 激活虚拟环境
export $(grep -v '^#' .env | xargs)   # 加载 .env
./scripts/ai_daily_report.sh          # 执行日报
```

**验证是否正常：**

- 脚本无报错退出 → 环境与配置基本正确。
- 若未收到 Telegram 消息 → 检查 Bot 是否已加入目标会话、Chat ID 是否正确、OpenClaw 侧是否配置了发送到 Telegram。

---

## 定时推送（可选）

希望每天固定时间（如早上 9 点）自动推送时，可使用 cron：

```bash
crontab -e
```

在末尾添加一行（**把 `/path/to/ai-daily-bot` 换成你的项目实际路径**）：

```bash
0 9 * * * cd /path/to/ai-daily-bot && . .venv/bin/activate && export $(grep -v '^#' .env | xargs) && ./scripts/ai_daily_report.sh >> ~/ai_daily.log 2>&1
```

保存后，每天 9:00 会自动执行一次，日志追加到 `~/ai_daily.log`。

---

## 工作原理简述

1. **定时或手动** 执行 `scripts/ai_daily_report.sh`。
2. 脚本读取 **`prompts/ai_daily_prompt.md`** 中的提示词，调用 **OpenClaw Agent**。
3. OpenClaw 侧可结合本项目的 **`config/sources.yaml`** 与 Python 模块（`src/ai_daily_bot/`）采集 RSS 等数据。
4. **LLM** 根据提示词对内容做摘要与整理。
5. 结果通过 **Telegram Bot**（或你配置的 telegram_send 等）发送到指定会话。

数据流可概括为：**配置与 Prompt → OpenClaw → 采集/摘要 → Telegram**。

---

## 项目结构

```
ai-daily-bot/
├── config/
│   ├── env.example    # 环境变量示例，复制为 .env 后填写
│   └── sources.yaml   # 数据源（RSS、链接）配置
├── prompts/           # 日报、周报的提示词模板
├── scripts/
│   ├── ai_daily_report.sh   # 日报入口
│   └── ai_weekly_report.sh  # 周报入口
├── src/ai_daily_bot/  # Python：采集、格式化、本地运行入口
├── tools/             # 外部工具配置（如 telegram_send）
├── docs/              # 架构与路线图
├── tests/             # 单元测试
├── .env               # 你的密钥（勿提交），由 env.example 复制而来
├── install.sh        # 一键安装
├── Makefile          # 开发用命令（lint、test 等）
└── README.md         # 本文件
```

---

## 常见问题

**Q：`python3: command not found` / 没有 Python？**  
A：请先安装 Python 3.9 或更高版本（如从 [python.org](https://www.python.org/downloads/) 或系统包管理器安装）。

**Q：执行 `./install.sh` 报错「Permission denied」？**  
A：执行 `chmod +x install.sh` 后再运行 `./install.sh`。

**Q：收不到 Telegram 消息？**  
A：确认 (1) Bot 已加入目标群或与用户有过私聊；(2) `.env` 中 `TELEGRAM_BOT_TOKEN` 和 `TELEGRAM_CHAT_ID` 正确；(3) OpenClaw 或当前脚本中已配置「发送到 Telegram」的逻辑。

**Q：如何只测试采集、不发 Telegram？**  
A：可单独运行 Python 模块查看采集结果：  
`source .venv/bin/activate && PYTHONPATH=src python -m ai_daily_bot.runner`  
（会从 `config/sources.yaml` 采集并打印格式化后的条目。）

更多问题可查看 [SUPPORT.md](SUPPORT.md) 或提交 [Issue](https://github.com/YOUR_USERNAME/ai-daily-bot/issues)。

---

## 参与开发

```bash
make install-dev   # 安装可编辑包与开发依赖
make lint          # 代码检查（ruff）
make format        # 代码格式化（ruff）
make test          # 运行测试
make test-cov      # 测试并生成覆盖率报告
```

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。提交前建议执行 `make lint && make test`。

---

## 文档与许可

- [架构说明](docs/architecture.md)
- [路线图](docs/roadmap.md)
- [安全与漏洞报告](SECURITY.md)

本项目采用 [MIT](LICENSE) 许可证。
