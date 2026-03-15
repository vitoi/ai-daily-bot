"""Tests for collector module."""

import tempfile
from pathlib import Path

from ai_daily_bot.collector import collect_titles, load_sources


def test_load_sources():
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yaml", delete=False) as f:
        f.write("rss:\n  - https://example.com/feed\n")
        path = f.name
    try:
        config = load_sources(path)
        assert "rss" in config
        assert config["rss"] == ["https://example.com/feed"]
    finally:
        Path(path).unlink(missing_ok=True)


def test_load_sources_empty_file(tmp_path):
    cfg = tmp_path / "empty.yaml"
    cfg.write_text("")
    config = load_sources(str(cfg))
    assert config == {}


def test_load_sources_no_rss_key(tmp_path):
    cfg = tmp_path / "sources.yaml"
    cfg.write_text("custom_urls:\n  - https://example.com\n")
    config = load_sources(str(cfg))
    assert "rss" not in config or config.get("rss") is None


def test_collect_titles_empty_rss(tmp_path):
    cfg = tmp_path / "sources.yaml"
    cfg.write_text("rss: []\n")
    result = collect_titles(str(cfg))
    assert result == []
