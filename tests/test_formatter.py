"""Tests for formatter module."""

from ai_daily_bot.formatter import format_candidates


def test_format_candidates_empty():
    assert format_candidates([]) == ""


def test_format_candidates_single():
    items = [{"title": "Hello", "link": "https://example.com/1"}]
    out = format_candidates(items)
    assert "1. Hello" in out
    assert "https://example.com/1" in out


def test_format_candidates_multiple():
    items = [
        {"title": "A", "link": "https://a.com"},
        {"title": "B", "link": "https://b.com"},
    ]
    out = format_candidates(items)
    assert "1. A" in out and "2. B" in out
    assert "https://a.com" in out and "https://b.com" in out
