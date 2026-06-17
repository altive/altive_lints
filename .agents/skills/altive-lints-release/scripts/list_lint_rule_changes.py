#!/usr/bin/env python3
"""List added and removed lint rules from all_lint_rules.yaml as Markdown."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys


RULE_RE = re.compile(r"^([+-])\s{4}-\s*([a-zA-Z][A-Za-z0-9_]+)\s*(?:#.*)?$")
TARGET = "packages/altive_lints/lib/all_lint_rules.yaml"


def read_diff(from_ref: str | None, to_ref: str | None) -> str:
    if not from_ref:
        return sys.stdin.read()

    range_ref = f"{from_ref}..{to_ref or 'HEAD'}"
    return subprocess.check_output(
        ["git", "diff", range_ref, "--", TARGET],
        text=True,
    )


def collect_rules(diff_text: str) -> tuple[list[str], list[str]]:
    added: list[str] = []
    removed: list[str] = []
    seen_added: set[str] = set()
    seen_removed: set[str] = set()

    for line in diff_text.splitlines():
        match = RULE_RE.match(line)
        if not match:
            continue

        sign, rule = match.groups()
        if sign == "+" and rule not in seen_added:
            seen_added.add(rule)
            added.append(rule)
        elif sign == "-" and rule not in seen_removed:
            seen_removed.add(rule)
            removed.append(rule)

    return added, removed


def print_section(title: str, rules: list[str]) -> None:
    if not rules:
        return

    print(f"   - {title}")
    for rule in rules:
        print(f"     - [{rule}](https://dart.dev/tools/linter-rules/{rule})")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Create Markdown Added/Removed lint rule lists from all_lint_rules.yaml changes.",
    )
    parser.add_argument("--from", dest="from_ref", help="Base git ref, such as altive_lints-v3.0.0.")
    parser.add_argument("--to", dest="to_ref", help="Target git ref. Defaults to HEAD when --from is used.")
    args = parser.parse_args()

    added, removed = collect_rules(read_diff(args.from_ref, args.to_ref))
    print_section("Added", added)
    print_section("Removed", removed)

    if not added and not removed:
        print("No lint rule additions or removals found.", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
