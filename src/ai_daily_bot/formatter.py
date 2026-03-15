"""将采集结果格式化为可读文本。"""


def format_candidates(items: list[dict[str, str]]) -> str:
    """将条目列表格式化为带编号的「标题 + 链接」多行文本。"""
    lines = []
    for i, item in enumerate(items, start=1):
        lines.append(f"{i}. {item['title']}")
        lines.append(f"   {item['link']}")
    return "\n".join(lines)
