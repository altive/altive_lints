# Altive Lints Plugin

Analyzer Plugin implementation for [`altive_lints`](https://pub.dev/packages/altive_lints).
It provides Altive custom lint rules, fixes, and assists.

Most users should not add this package to `pubspec.yaml`. Instead, install
`altive_lints` and include its analysis options:

```yaml
# pubspec.yaml
dev_dependencies:
  altive_lints: ^4.0.0
```

```yaml
# analysis_options.yaml
include: package:altive_lints/altive_lints.yaml
```

The analysis server resolves this plugin separately from the consuming pub
workspace. See the
[`altive_lints` README](https://pub.dev/packages/altive_lints) for available
rules and configuration.
