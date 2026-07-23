---
name: altive-lints-release
description: Manual release workflow for the altive_lints preset and altive_lints_plugin packages. Use when Codex needs to prepare a release without running melos version: review changes, choose SemVer versions, maintain useful changelogs, validate both packages, and publish the plugin before the preset.
---

<!-- cspell:words creatordate oneline pubspec -->

# Altive Lints Release

## Overview

Prepare releases for `packages/altive_lints` and, when changed,
`packages/altive_lints_plugin` without using `melos version`. The preset refers
to the plugin from `altive_lints.yaml`, so publish the plugin first whenever a
release changes both packages.

## Core Rule

Do not run `melos version`. It writes a minimal changelog entry and hides the most important release detail for this package: which Dart lint rules were added or removed.

## Workflow

1. Check repository state.
   - Inspect `git status --short --branch`.
   - Confirm the current branch is the intended release branch, usually `main`.
   - Never revert unrelated user changes. If unrelated changes exist, leave them unstaged.
2. Identify the latest release tag.
   - Use the newest `altive_lints-v*` tag from `git tag --sort=-creatordate`.
   - When the plugin changed, also use the newest `altive_lints_plugin-v*` tag.
   - Summarize changes with `git log --oneline --decorate <tag>..HEAD`.
   - Inspect file scope with `git diff --stat <tag>..HEAD`.
3. Decide the next version.
   - Use the user-requested version when provided.
   - Otherwise choose SemVer from the actual changes:
     - patch: docs, test, CI, or internal fixes with no behavior/API change.
     - minor: added lint rules, new diagnostics, new assists, or compatible dependency support.
     - major: breaking SDK/dependency constraints, removed public behavior, or incompatible rule behavior.
   - Read the current version from `packages/altive_lints/pubspec.yaml`.
4. Extract lint rule additions and removals.
   - Run the bundled script when `all_lint_rules.yaml` changed:

```bash
python3 .agents/skills/altive-lints-release/scripts/list_lint_rule_changes.py --from altive_lints-vX.Y.Z
```

   - The script prints Markdown for `Added` and `Removed` sections.
   - Verify rename-like changes by checking the diff manually. If a rule spelling changed, list the new rule under `Added` and the old rule under `Removed`.
   - Use official rule links in this form: `https://dart.dev/tools/linter-rules/<rule_name>`.
5. Update `packages/altive_lints/CHANGELOG.md`.
   - When the plugin changed, also update
     `packages/altive_lints_plugin/CHANGELOG.md`.
   - Add the new version section at the top.
   - Base the notes on commits and actual diffs since the latest release tag.
   - For `all_lint_rules.yaml` changes, do not write only "update all_lint_rules"; always list the added and removed rules.
   - Match the existing changelog style:

```markdown
## X.Y.Z

 - **FEAT**: update all_lint_rules (#NNN).
   - Added
     - [rule_name](https://dart.dev/tools/linter-rules/rule_name)
   - Removed
     - [old_rule_name](https://dart.dev/tools/linter-rules/old_rule_name)
```

6. Update `packages/altive_lints/pubspec.yaml`.
   - Set `version:` to the chosen version.
   - When the plugin changed, update its `pubspec.yaml` and keep the version
     constraint in `altive_lints.yaml` compatible with that release.
   - Do not modify unrelated fields.
7. Validate before committing.
   - Inspect `git diff`.
   - Run focused validation when feasible:
     - `flutter analyze`
     - `(cd packages/altive_lints_plugin && dart test)`
     - `dart run tool/verify_v4_split.dart`
     - `(cd packages/altive_lints_plugin && dart pub publish --dry-run)`
     - `(cd packages/altive_lints && dart pub publish --dry-run)`
   - If a validation command cannot run, report why.
8. Create the release commit.
   - Stage only release files, normally:
     - `packages/altive_lints/CHANGELOG.md`
     - `packages/altive_lints/pubspec.yaml`
     - `packages/altive_lints_plugin/CHANGELOG.md` when changed
     - `packages/altive_lints_plugin/pubspec.yaml` when changed
   - Use Conventional Commit:

```bash
git commit -m "chore(release): altive_lints X.Y.Z"
```

9. Create the release tag.
   - Use `altive_lints-vX.Y.Z`.
   - Use `altive_lints_plugin-vX.Y.Z` when releasing the plugin.
   - Do not retarget an existing tag unless the release commit is still local/unpushed and the situation is verified.

```bash
git tag altive_lints-vX.Y.Z
```

10. Provide final commands.
   - Always include the push command.
   - Always include the pub.dev publish commands in plugin-then-preset order.
   - After publishing the plugin and before publishing the preset, run
     `make verify-published-plugin` to verify hosted resolution with the
     unchanged example.
   - Include the dry-run command when useful or when it was not already run successfully.

## Command Output Rules

Present the push command in this form:

```bash
git push origin main altive_lints-vX.Y.Z
```

Present the pub.dev publish command in this form:

```bash
(cd /ABSOLUTE/PATH/TO/packages/altive_lints_plugin && dart pub publish)
make verify-published-plugin
(cd /ABSOLUTE/PATH/TO/packages/altive_lints && dart pub publish)
```

When useful, also provide the dry-run command:

```bash
(cd /ABSOLUTE/PATH/TO/packages/altive_lints_plugin && dart pub publish --dry-run)
(cd /ABSOLUTE/PATH/TO/packages/altive_lints && dart pub publish --dry-run)
```

## Editing Rules

- Briefly state which files will be edited before making changes.
- Use `apply_patch` for manual edits.
- Do not stage or commit unrelated user changes.
- Do not run `git push` or `dart pub publish` automatically unless the user explicitly asks for execution.
- If a release commit/tag already exists locally and the user asks for changelog fixes before push, amend the local release commit and retag only after verifying it has not been pushed.

## Response Rules

- Start by stating the latest release tag, the chosen next version, and the main changes since that tag.
- Mention added and removed lint rules explicitly when present.
- State which files were updated, which commit was created, and which tag was created.
- Finish with the exact push and pub.dev publish commands the user can run as-is.
- List deployable files if any; the usual deploy action is publishing
  `packages/altive_lints_plugin` first and then `packages/altive_lints` to
  pub.dev, not deploying infrastructure files.
