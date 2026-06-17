---
name: review-lint-rule-pr
description: Review GitHub pull requests that update packages/altive_lints/lib/all_lint_rules.yaml by adding Dart linter rules. Use when Codex needs to inspect an all_lint_rules PR, identify newly added rules, open each official dart.dev linter-rule URL, explain each rule in Japanese, summarize pros and cons, and advise whether Altive should adopt or reject the rule in its recommended lint set.
---

# Review Lint Rule PR

## Overview

Review PRs that add Dart lint rules to `all_lint_rules.yaml` and turn official rule documentation plus repository context into a practical Japanese adoption recommendation.

## Workflow

1. Confirm the PR and repository state.
   - Inspect `git status --short` before making any local changes.
   - Treat user changes as out of scope; never revert them.
   - Use the PR URL or number from the user. Example: `https://github.com/altive/altive_lints/pull/130`.
2. Inspect the PR diff.
   - Prefer GitHub-native context when available: PR title, description, changed files, and diff.
   - If `gh` is available, `gh pr diff <number>` is a good source for raw diff.
   - Focus on `packages/altive_lints/lib/all_lint_rules.yaml`.
3. Extract added lint rule names.
   - Use `scripts/extract_added_lint_rules.py` with a raw diff when possible.
   - Ignore YAML comments, removals, unchanged context, and non-rule additions.
   - If no rule is extracted automatically, manually inspect added `+    - rule_name` lines.
   - Also inspect nearby removed `-    - rule_name` lines. A paired removal and addition may be a rename, casing change, or upstream rule-name correction rather than a pure new rule.
4. Research each rule from official documentation.
   - Open `https://dart.dev/tools/linter-rules/<rule_name>` for every added rule.
   - For rename-like changes, open both the removed and added rule URLs and verify which spelling exists in the current official docs.
   - Also check the PR discussion when it explains why the rule appeared.
   - Use current official docs; do not rely only on memory for rule behavior.
   - When multiple rules are added and subagents are available, split official-doc research by rule. Give each subagent only the rule name, official URL, and requested output fields; then integrate the results yourself.
5. Compare with Altive policy context.
   - `all_lint_rules.yaml` is intentionally exhaustive, so adding a valid new Dart rule there is normally acceptable.
   - Adoption advice should target whether the rule should be enabled in Altive's recommended set, usually `packages/altive_lints/lib/altive_lints.yaml`, or whether follow-up action is needed.
   - Check whether the rule conflicts with existing rules or project style, creates likely false positives, requires large migrations, or is deprecated/experimental.
6. Answer in Japanese.
   - Lead with a short conclusion for the PR as a whole.
   - Then provide one section per added rule.
   - Include concrete advice, not only a documentation summary.

## Extraction Script

Run from this skill directory or pass the absolute script path:

```bash
gh pr diff 130 | python3 .agents/skills/review-lint-rule-pr/scripts/extract_added_lint_rules.py
```

For a saved diff:

```bash
python3 .agents/skills/review-lint-rule-pr/scripts/extract_added_lint_rules.py /tmp/pr.diff
```

The script prints one rule name per line. It is intentionally conservative and only reports additions that look like Dart lint rule YAML list entries inside `all_lint_rules.yaml`.

## Research Checklist

For each rule, capture:

- Official URL: `https://dart.dev/tools/linter-rules/<rule_name>`
- What the rule detects in plain Japanese.
- Good and bad code examples when useful, summarized rather than copied.
- Whether the rule is a style rule, correctness/safety rule, documentation rule, performance rule, or Flutter-specific rule.
- Autofix availability, if the official page or analyzer tooling makes it clear.
- Expected migration cost for existing apps.
- False positive or readability risk.
- Interaction with strict inference, generated code, public API docs, Flutter UI code, or package/plugin code when relevant.
- Whether the change is a pure addition or a rename/casing correction from an existing rule.

## Recommendation Criteria

Use these defaults unless repository context says otherwise:

- **Adopt strongly**: correctness, safety, null-safety, async misuse, API misuse, or low-noise consistency rules.
- **Adopt with migration plan**: useful rule but likely to produce many findings, require mechanical edits, or touch public APIs.
- **Keep only in all_lint_rules for now**: opinionated style rules, rules with frequent legitimate exceptions, rules that fight common Flutter/Dart idioms, or rules that reduce readability for the team.
- **Do not adopt / investigate first**: deprecated rules, rules missing from current official docs, rules that conflict with another enabled rule, or rules with unclear analyzer support.
- **Request PR correction**: rename-like changes where the added rule URL does not exist, the analyzer would treat the rule as unknown, or the official spelling differs from the PR.

For `all_lint_rules.yaml` itself, recommend merging when the rule exists in current official docs and the PR only syncs the exhaustive list. If the rule has been removed or deprecated upstream, advise blocking or requesting correction.

## Output Format

Use this structure:

```markdown
結論: ...

追加されたルール:
- [`rule_name`](https://dart.dev/tools/linter-rules/rule_name): 採用判断

## rule_name

概要:
...

メリット:
- ...

デメリット・注意点:
- ...

Altiveでの採用アドバイス:
...
```

If multiple rules share the same conclusion, group them after still giving each rule enough individual reasoning.
