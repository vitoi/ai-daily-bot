# 开发常用命令（需在项目根目录执行）
.PHONY: install install-dev lint format test test-cov clean help

help:
	@echo "用法: make <目标>"
	@echo ""
	@echo "  install     创建 venv 并安装生产依赖"
	@echo "  install-dev 安装可编辑包 + 开发依赖（ruff, pytest, pytest-cov）"
	@echo "  lint        运行 ruff check"
	@echo "  format      运行 ruff format（原地格式化）"
	@echo "  test        运行 pytest"
	@echo "  test-cov    运行 pytest 并生成覆盖率报告"
	@echo "  clean       删除缓存与覆盖率产物"

install:
	./install.sh

install-dev: install
	. .venv/bin/activate && pip install -e ".[dev]" && pip install pytest-cov

lint:
	. .venv/bin/activate && ruff check src/ tests/

format:
	. .venv/bin/activate && ruff format src/ tests/

test:
	. .venv/bin/activate && PYTHONPATH=src pytest tests/ -v --tb=short

test-cov:
	. .venv/bin/activate && PYTHONPATH=src pytest tests/ -v --tb=short --cov=ai_daily_bot --cov-report=term-missing --cov-report=html

clean:
	rm -rf .pytest_cache .ruff_cache .coverage htmlcov coverage.xml
