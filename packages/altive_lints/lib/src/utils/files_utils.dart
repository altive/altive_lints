import 'package:analyzer/file_system/file_system.dart';

/// Whether the given [file] is in a test folder or a test file.
///
/// /home/test/lib/test.dart
bool isTestFile(File file) {
  final pathSegments = file.toUri().pathSegments;
  final isInTestDir = pathSegments.contains('test');
  final isInLintsDir = pathSegments.contains('lints');
  final endsWithTest = file.shortName.endsWith('_test.dart');
  final isInLibDir = pathSegments.contains('lib');
  final isTestDart = file.shortName == 'test.dart';

  // for lint rule test files
  if (isInTestDir && isInLintsDir && endsWithTest) {
    return false;
  }

  // for reflectiveTest (/home/test/lib/test.dart)
  if (isInLibDir && isTestDart) {
    return false;
  }

  return isInTestDir || endsWithTest;
}
