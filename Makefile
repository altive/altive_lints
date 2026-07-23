.PHONY: publish-dry-run publish-altive-lints-plugin verify-published-plugin publish-altive-lints

publish-dry-run:
	cd packages/altive_lints_plugin && dart pub publish --dry-run
	cd packages/altive_lints && dart pub publish --dry-run

publish-altive-lints-plugin:
	cd packages/altive_lints_plugin && dart pub publish

verify-published-plugin:
	cd packages/altive_lints/example && flutter pub get
	cd packages/altive_lints/example && dart analyze

publish-altive-lints:
	cd packages/altive_lints && dart pub publish
