import 'package:altive_lints/src/utils/files_utils.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:test/test.dart';

void main() {
  group('isTestFile', () {
    test('False if it is a not test file', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/lib/src/implementation.dart';
      final file = resourceProvider.getFile(filePath);
      expect(isTestFile(file), isFalse);
    });

    test('True if it is a test file', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/lib/src/implementation_test.dart';
      final file = resourceProvider.getFile(filePath);
      expect(isTestFile(file), isTrue);
    });

    test('True if it is a test directory', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/test/src/util.dart';
      final file = resourceProvider.getFile(filePath);
      expect(isTestFile(file), isTrue);
    });

    test('False if path contains test but not in test directory', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/testfile.dart';
      final file = resourceProvider.getFile(filePath);
      expect(isTestFile(file), isFalse);
    });

    test(
      'False if the path or directory contains the string "test" '
      'but it is not an exact match',
      () {
        final resourceProvider = PhysicalResourceProvider.INSTANCE;

        const filePath = '/project/testable/testable_file.dart';
        final file = resourceProvider.getFile(filePath);
        expect(isTestFile(file), isFalse);
      },
    );

    test('False if it is in lib directory and file name is test.dart', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/home/test/lib/test.dart';
      final file = resourceProvider.getFile(filePath);
      expect(isTestFile(file), isFalse);
    });

    test(
      'False if it is in test dir and lints dir and ends with _test.dart',
      () {
        final resourceProvider = PhysicalResourceProvider.INSTANCE;

        const filePath =
            '/project/test/src/lints/avoid_hardcoded_japanese_test.dart';
        final file = resourceProvider.getFile(filePath);
        expect(isTestFile(file), isFalse);
      },
    );
  });
}
