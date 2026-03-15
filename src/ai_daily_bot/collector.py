"""RSS 与配置源加载、条目采集。"""

from __future__ import annotations

from typing import Any

import feedparser
import yaml


def load_sources(config_path: str) -> dict[str, Any]:
    """从 YAML 文件加载源配置（如 rss、custom_urls）。"""
    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def collect_titles(config_path: str) -> list[dict[str, str]]:
    """从配置中的 RSS 源抓取每条前 5 条条目的标题与链接。"""
    config = load_sources(config_path)
    results: list[dict[str, str]] = []
    for url in config.get("rss", []):
        feed = feedparser.parse(url)
        for entry in feed.entries[:5]:
            results.append(
                {
                    "title": entry.get("title", ""),
                    "link": entry.get("link", ""),
                }
            )
    return results
