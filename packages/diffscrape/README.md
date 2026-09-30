# Diffscrape

## What is it?

Diffscrape is a tool for scraping web and file diffs.

## Interface

### uri
URL of the scraping destination.

### file
Files to be compared. Any differences will be overwritten.

### query-selector
Selector for searching elements in HTML.

A sample command-line application providing basic argument parsing with an entrypoint in `bin/`.

```shell
dart run diffscrape \
--uri "https://dart.dev/tools/linter-rules/all" \
--file "../altive_lints/lib/all_lint_rules.yaml" \
--query-selector "pre code.yaml" \
--verbose
```

When updating `all_lint_rules.yaml`, remove `unnecessary_await_in_return` from
the generated list. Dart still includes it on the all-rules page even though
the rule is deprecated. The scheduled update workflow removes it automatically.
