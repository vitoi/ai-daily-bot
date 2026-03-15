"""命令行入口：从默认配置采集并输出格式化结果。"""

from pathlib import Path

from ai_daily_bot.collector import collect_titles
from ai_daily_bot.formatter import format_candidates


def main() -> None:
    """从项目 config/sources.yaml 采集并打印格式化后的候选条目。"""
    root = Path(__file__).resolve().parents[2]
    config_path = root / "config" / "sources.yaml"
    items = collect_titles(str(config_path))
    print(format_candidates(items))


if __name__ == "__main__":
    main()
