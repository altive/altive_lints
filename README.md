[![Check all lint rule diffs](https://github.com/altive/altive_lints/actions/workflows/update-all-lint-rules.yaml/badge.svg)](https://github.com/altive/altive_lints/actions/workflows/update-all-lint-rules.yaml)

# Altive Lints

Provides `all_lint_rules.yaml` that activates all rules and `altive_lints.yaml` with Altive recommended rule selection.

## Getting started

```yaml
dev_dependencies:
  altive_lints: any
```

### Compatibility

`altive_lints` 4.x keeps the preset analyzer-independent and resolves its
Analyzer Plugin separately. It can therefore be used by Flutter 3.44.7
workspaces that contain both `flutter_test` and Dart packages using `test`.
See the
[SDK and package compatibility table](packages/altive_lints/README.md#sdk-and-package-compatibility)
for details.

### Migrating to v4

The standard setup is unchanged: depend on `altive_lints: ^4.0.0` and include
`package:altive_lints/altive_lints.yaml`. Do not add
`altive_lints_plugin` to the application's `pubspec.yaml`; the analysis server
resolves it separately.

Existing ignore comments must change from `altive_lints/<rule>` to
`altive_lints_plugin/<rule>`. Restart the Dart Analysis Server after upgrading.
See the [full v4 migration guide](packages/altive_lints/README.md#v400).

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
