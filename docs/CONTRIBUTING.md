# Contribution Guide

## Welcome the creation of issues and pull requests

TODO

## Publication to pub.dev

`altive_lints` references `altive_lints_plugin` from its bundled analysis
options, so publish the plugin first whenever both packages change.

1. Review changes since the latest tags.
    - `git tag --sort=-creatordate | grep '^altive_lints' | head`
    - `git log --oneline <tag>..HEAD`
    - `git diff --stat <tag>..HEAD`
1. Update both changelogs and package versions as needed.
    - `packages/altive_lints_plugin/CHANGELOG.md`
    - `packages/altive_lints_plugin/pubspec.yaml`
    - `packages/altive_lints/CHANGELOG.md`
    - `packages/altive_lints/pubspec.yaml`
    - When `all_lint_rules.yaml` changes, list added and removed rules with
      links to `https://dart.dev/tools/linter-rules/<rule_name>`.
1. Validate the workspace and both archives.
    - `flutter analyze`
    - `dart test packages/altive_lints_plugin`
    - `dart run tool/verify_v4_split.dart` (also analyzes the real example
      sources with every custom diagnostic enabled)
    - `(cd packages/altive_lints_plugin && dart pub publish --dry-run)`
    - `(cd packages/altive_lints && dart pub publish --dry-run)`
1. Create the release commit and package tags.
    - Use `altive_lints_plugin-vX.Y.Z` for the plugin.
    - Use `altive_lints-vX.Y.Z` for the preset.
1. Push the release commit and tags.
1. Publish from `main` in this order:
    1. `make publish-altive-lints-plugin`
    2. Confirm the hosted plugin works with the unchanged example by running
       `make verify-published-plugin`.
    3. `make publish-altive-lints`

```shell
# Dry-run before publishing.
make publish-dry-run

# Publish to pub.dev in dependency order.
(cd packages/altive_lints_plugin && dart pub publish)
(cd packages/altive_lints && dart pub publish)
```
