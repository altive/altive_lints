import 'package:analyzer/source/source.dart';

/// Whether the given [source] is a test file.
bool isTestFile(Source source) {
  return source.uri.pathSegments.contains('test') ||
      source.shortName.endsWith('_test.dart');
}
