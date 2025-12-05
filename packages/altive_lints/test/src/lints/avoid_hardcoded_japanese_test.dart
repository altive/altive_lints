// Because it's a test
// ignore_for_file: altive_lints/avoid_hardcoded_japanese
import 'package:altive_lints/src/lints/avoid_hardcoded_japanese.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidHardcodedJapaneseTest);
  });
}

@reflectiveTest
class AvoidHardcodedJapaneseTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = AvoidHardcodedJapanese();
    super.setUp();
  }

  Future<void> test_simple_string_literal_with_japanese() async {
    await assertDiagnostics(
      '''
  void f() {
    final message = 'こんにちは';
  }
  ''',
      [lint(33, 7)],
    );
  }

  Future<void> test_string_interpolation_with_japanese() async {
    await assertDiagnostics(
      '''
  void f() {
    print('エラーが発生しました');
  }
  ''',
      [lint(23, 12)],
    );
  }

  Future<void> test_simple_string_literal_without_japanese() async {
    await assertNoDiagnostics('''
void f() {
  final message = 'Hello';
}
''');
  }

  Future<void> test_string_interpolation_without_japanese() async {
    await assertNoDiagnostics('''
void f() {
  print('Error occurred');
}
''');
  }

  Future<void> test_hiragana() async {
    await assertDiagnostics(
      '''
  void f() {
    final message = 'あいうえお';
  }
  ''',
      [lint(33, 7)],
    );
  }

  Future<void> test_katakana() async {
    await assertDiagnostics(
      '''
  void f() {
    final message = 'アイウエオ';
  }
  ''',
      [lint(33, 7)],
    );
  }

  Future<void> test_kanji() async {
    await assertDiagnostics(
      '''
  void f() {
    final message = '日本語';
  }
  ''',
      [lint(33, 5)],
    );
  }
}
