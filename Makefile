.PHONY: publish-dry-run publish-altive-lints-plugin publish-altive-lints

publish-dry-run:
	cd packages/altive_lints_plugin && dart pub publish --dry-run
	cd packages/altive_lints && dart pub publish --dry-run

publish-altive-lints-plugin:
	cd packages/altive_lints_plugin && dart pub publish

publish-altive-lints:
	cd packages/altive_lints && dart pub publish
