# Altive Lints

Provides `all_lint_rules.yaml` that activates all rules and `altive_lints.yaml` with Altive recommended rule selection.

## Getting started

```yaml
dev_dependencies:
  altive_lints: any
```

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
