---
name: altive-lints-release
description: Release workflow for the altive_lints package. Use when Codex needs to review changes since the latest release tag, update CHANGELOG.md, bump the version in packages/altive_lints/pubspec.yaml, create the release commit and tag, and finally provide the commands to push the commit and tag to the remote and publish to pub.dev.
---

<!-- cspell:words creatordate oneline -->

# Altive Lints Release

## Overview

Prepare a release for `packages/altive_lints` using a consistent workflow. Cover change review, version updates, release commit and tag creation, and finally provide the exact `push` and `dart pub publish` commands.

## Workflow

1. Check the repository state.
   - Inspect `git status --short` to see whether there are uncommitted changes.
   - Never revert unrelated user changes.
2. Identify the latest release tag.
   - Use the newest `altive_lints-v*` tag from `git tag --sort=-creatordate`.
   - When needed, summarize changes with `git log --oneline --decorate <tag>..HEAD` and `git diff --stat <tag>..HEAD`.
3. Update the changelog.
   - Edit `packages/altive_lints/CHANGELOG.md`.
   - Add the new version section at the top.
   - Base the release notes on commits and actual file diffs since the tag.
   - When a lint rule is added, include the Dart lint rule link.
4. Bump the version.
   - Edit `packages/altive_lints/pubspec.yaml`.
   - Set it to the user-requested version.
5. Review the diff and create the release commit.
   - The usual release changes are `CHANGELOG.md` and `pubspec.yaml`.
   - Use the commit message `chore(release): altive_lints X.Y.Z`.
6. Create the release tag.
   - Use the tag name `altive_lints-vX.Y.Z`.
   - Only retarget an existing tag when the situation has been verified.
7. Provide the final execution commands.
   - Present the `push` command in one line.
   - Present the `publish` command in one line without changing the caller's working directory.
   - Always include the `pub.dev` publish command in the final response.

## Command Output Rules

- Present the `push` command in this form.

```bash
git push origin main altive_lints-vX.Y.Z
```

- Present the `pub.dev` publish command in this form.

```bash
(cd /ABSOLUTE/PATH/TO/packages/altive_lints && dart pub publish)
```

- When useful, also provide the dry-run command.

```bash
(cd /ABSOLUTE/PATH/TO/packages/altive_lints && dart pub publish --dry-run)
```

## Editing Rules

- Briefly state which files will be edited before making changes.
- Use `apply_patch` for manual edits.
- Do not revert unrelated existing changes.
- Do not run `push` or `publish` automatically unless the user explicitly asks for execution. Provide the commands at the end.

## Response Rules

- Start by briefly stating the latest tag and the main changes since that tag.
- At the end, state which files were updated, which commit was created, and which tag was created.
- Finish by presenting the exact commands the user can run as-is.
- Always include the `pub.dev` publish command, and include the dry-run command when it is useful.
