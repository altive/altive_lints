# Contribution Guide

## Welcome the creation of issues and pull requests

TODO

## Publication to pub.dev

1. Create a release branch.
    - `git switch -c release` & `git push -u origin release`
1. Create a release commit.
    - `melos version`
1. Push a commit with a tag.
    -  `git push origin release --tags`
    -  Open a pull-request.
1. Merge after approving pull-request.
1. Publish to pub.dev.
    - `melos publish` on the `main` branch.

```shell
# Use melos version command.
melos version
# Example of manually specifying a version.
melos version --manual-version altive_lints:patch
```
