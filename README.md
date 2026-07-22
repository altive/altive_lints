[![Check all lint rule diffs](https://github.com/altive/altive_lints/actions/workflows/update-all-lint-rules.yaml/badge.svg)](https://github.com/altive/altive_lints/actions/workflows/update-all-lint-rules.yaml)

# Altive Lints

Provides `all_lint_rules.yaml` that activates all rules and `altive_lints.yaml` with Altive recommended rule selection.

## Getting started

```yaml
dev_dependencies:
  altive_lints: any
```

### Compatibility

`altive_lints` 3.x requires analyzer 13. Flutter 3.44.7 workspaces that contain
both `flutter_test` and Dart packages using `test` cannot resolve that version;
use `altive_lints: ^2.3.0` temporarily. See the
[SDK and package compatibility table](packages/altive_lints/README.md#sdk-and-package-compatibility)
for details.

## Usage

### altive_lints

1. Copy [analysis_options.yaml](https://github.com/altive/altive_lints/blob/main/packages/altive_lints/example/analysis_options.yaml) to your project root.
2. Add your rules if needed.

### all_lint_rules

1. Copy [analysis_options.yaml](https://github.com/altive/altive_lints/blob/main/packages/altive_lints/example/analysis_options.yaml) to your project root.
2. Rewrite "altive_lints.yaml" to "all_lint_rules.yaml".

```
# https://pub.dev/packages/altive_lints
include: package:altive_lints/all_lint_rules.yaml
```

3. Add your rules if needed.

## Related All Lint Rules

https://dart.dev/tools/linter-rules/all

## Development

See [CONTRIBUTING.md](/docs/CONTRIBUTING.md).
