# 贡献指南

感谢你对 AI Daily Bot 的关注与贡献。

## 如何贡献

- **报告问题**：在 [Issues](https://github.com/YOUR_USERNAME/ai-daily-bot/issues) 中提交 Bug 或功能建议，请尽量使用模板并填写清晰描述。
- **提交代码**：Fork 本仓库，在分支上修改后提交 Pull Request，并关联相关 Issue（如有）。

## 开发环境

```bash
git clone https://github.com/YOUR_USERNAME/ai-daily-bot.git
cd ai-daily-bot
./install.sh
source .venv/bin/activate
pip install -r requirements.txt
# 可选：以可编辑模式安装包并安装开发依赖（推荐使用 make install-dev）
pip install -e ".[dev]"
pip install pytest-cov
# 或：make install-dev
```

## 代码规范

- Python 代码请遵循 PEP 8，建议使用 [ruff](https://github.com/astral-sh/ruff) 进行格式与 lint 检查。
- 提交前可在本地运行：`make lint`、`make format`、`make test`；或安装 [pre-commit](https://pre-commit.com/) 后执行 `pre-commit run --all-files`。

## Pull Request

- 请保持 PR 范围清晰，一个 PR 尽量只解决一个问题或一个功能。
- 描述中请说明改动目的与测试方式，便于维护者审核。

再次感谢你的参与。
