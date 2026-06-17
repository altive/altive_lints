# Contribution Guide

## Welcome the creation of issues and pull requests

TODO

## Publication to pub.dev

1. Review changes since the latest release tag.
    - `git tag --sort=-creatordate | grep '^altive_lints-v' | head`
    - `git log --oneline <tag>..HEAD`
    - `git diff --stat <tag>..HEAD`
1. Update the release notes.
    - Edit `packages/altive_lints/CHANGELOG.md`.
    - When `all_lint_rules.yaml` changed, list added and removed rules with links to `https://dart.dev/tools/linter-rules/<rule_name>`.
1. Bump the package version.
    - Edit `packages/altive_lints/pubspec.yaml`.
1. Validate the package.
    - `dart analyze packages/altive_lints`
    - `(cd packages/altive_lints && dart test)`
    - `(cd packages/altive_lints && dart pub publish --dry-run)`
1. Create a release commit and tag.
    - `git add packages/altive_lints/CHANGELOG.md packages/altive_lints/pubspec.yaml`
    - `git commit -m "chore(release): altive_lints X.Y.Z"`
    - `git tag altive_lints-vX.Y.Z`
1. Push the release commit and tag.
    - `git push origin main altive_lints-vX.Y.Z`
1. Publish to pub.dev on the `main` branch.
    - `(cd packages/altive_lints && dart pub publish)`

```shell
# Dry-run before publishing.
(cd packages/altive_lints && dart pub publish --dry-run)

# Publish to pub.dev.
(cd packages/altive_lints && dart pub publish)
```
