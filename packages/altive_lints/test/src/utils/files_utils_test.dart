import 'package:altive_lints/src/utils/files_utils.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/source/file_source.dart';
import 'package:test/test.dart';

void main() {
  group('isTestFile', () {
    test('False if it is a not test file', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/lib/src/implementation.dart';
      final file = resourceProvider.getFile(filePath);
      final source = FileSource(file);
      expect(isTestFile(source), isFalse);
    });

    test('True if it is a test file', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/lib/src/implementation_test.dart';
      final file = resourceProvider.getFile(filePath);
      final source = FileSource(file);
      expect(isTestFile(source), isTrue);
    });

    test('True if it is a test directory', () {
      final resourceProvider = PhysicalResourceProvider.INSTANCE;

      const filePath = '/project/test/src/util.dart';
      final file = resourceProvider.getFile(filePath);
      final source = FileSource(file);
      expect(isTestFile(source), isTrue);
    });
  });
}
