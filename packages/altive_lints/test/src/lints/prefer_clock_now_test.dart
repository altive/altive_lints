import 'package:altive_lints/src/lints/prefer_clock_now.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferClockNowTest);
  });
}

@reflectiveTest
class PreferClockNowTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferClockNow();
    super.setUp();
  }

  Future<void> test_has_datetime_now() async {
    await assertDiagnostics(
      '''
void f() {
  DateTime.now();
}
''',
      [lint(13, 14)],
    );
  }

  Future<void> test_no_datetime_now() async {
    await assertNoDiagnostics('''
class Clock {
  int now() => 0;
}
final clock = Clock();
void f() {
  clock.now();
}
''');
  }
}
