import 'dart:io';

import 'package:diffscrape/diffscrape.dart';
import 'package:test/test.dart';

void main() {
  group('scrape', () {
    test('no changed rules', () async {
      final file = File('./test/data/no_changed_rules.yaml');
      final oldValue = await file.readAsString();
      final diffs = await scrape(
        uriPath: 'https://dart.dev/tools/linter-rules/all',
        filePath: file.path,
        querySelector: 'pre code.yaml',
        verbose: true,
      );

      addTearDown(
        () => file.writeAsString('$oldValue', mode: FileMode.writeOnly),
      );

      expect(diffs.inserts, isEmpty);
      expect(diffs.deletes, isEmpty);
    });

    test('inserted and deleted rules', () async {
      final file = File('./test/data/inserted_and_deleted_rules.yaml');
      final oldValue = await file.readAsString();
      final diffs = await scrape(
        uriPath: 'https://dart.dev/tools/linter-rules/all',
        filePath: file.path,
        querySelector: 'pre code.yaml',
        verbose: true,
      );

      addTearDown(
        () => file.writeAsString('$oldValue', mode: FileMode.writeOnly),
      );

      expect(diffs.inserts, hasLength(6));
      expect(diffs.deletes, hasLength(7));
    });

    test('inserted rules', () async {
      final file = File('./test/data/inserted_rules.yaml');
      final oldValue = await file.readAsString();
      final diffs = await scrape(
        uriPath: 'https://dart.dev/tools/linter-rules/all',
        filePath: file.path,
        querySelector: 'pre code.yaml',
        verbose: true,
      );

      addTearDown(
        () => file.writeAsString('$oldValue', mode: FileMode.writeOnly),
      );

      expect(diffs.inserts, hasLength(6));
      expect(diffs.deletes, isEmpty);
    });

    test('deleted rules', () async {
      final file = File('./test/data/deleted_rules.yaml');
      final oldValue = await file.readAsString();
      final diffs = await scrape(
        uriPath: 'https://dart.dev/tools/linter-rules/all',
        filePath: file.path,
        querySelector: 'pre code.yaml',
        verbose: true,
      );

      addTearDown(
        () => file.writeAsString('$oldValue', mode: FileMode.writeOnly),
      );

      expect(diffs.inserts, isEmpty);
      expect(diffs.deletes, hasLength(7));
    });
  });
}
