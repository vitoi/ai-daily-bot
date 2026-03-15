"""Tests for runner module."""

from unittest.mock import patch

from ai_daily_bot.runner import main


@patch("ai_daily_bot.runner.format_candidates")
@patch("ai_daily_bot.runner.collect_titles")
def test_main_prints_formatted_output(mock_collect, mock_format):
    mock_collect.return_value = [
        {"title": "Test", "link": "https://example.com"},
    ]
    mock_format.return_value = "1. Test\n   https://example.com"

    with patch("builtins.print") as mock_print:
        main()
    mock_print.assert_called_once_with("1. Test\n   https://example.com")
