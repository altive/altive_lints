#!/usr/bin/env python3
"""Extract added Dart lint rule names from an all_lint_rules.yaml diff."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


RULE_RE = re.compile(r"^\+\s*-\s*([a-z][a-z0-9_]+)\s*(?:#.*)?$")
DIFF_FILE_RE = re.compile(r"^\+\+\+\s+b/(.+)$")


def read_input(path: str | None) -> str:
    if path:
        return Path(path).read_text(encoding="utf-8")
    return sys.stdin.read()


def extract_rules(diff_text: str) -> list[str]:
    rules: list[str] = []
    seen: set[str] = set()
    current_file = ""

    for line in diff_text.splitlines():
        file_match = DIFF_FILE_RE.match(line)
        if file_match:
            current_file = file_match.group(1)
            continue

        if current_file and not current_file.endswith("all_lint_rules.yaml"):
            continue

        match = RULE_RE.match(line)
        if not match:
            continue

        rule = match.group(1)
        if rule not in seen:
            seen.add(rule)
            rules.append(rule)

    return rules


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract added Dart lint rule names from an all_lint_rules.yaml unified diff.",
    )
    parser.add_argument("diff", nargs="?", help="Path to a diff file. Reads stdin when omitted.")
    args = parser.parse_args()

    for rule in extract_rules(read_input(args.diff)):
        print(rule)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
