import 'package:altive_lints/src/lints/prefer_space_between_elements.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferSpaceBetweenElementsTest);
  });
}

@reflectiveTest
class PreferSpaceBetweenElementsTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferSpaceBetweenElements();
    super.setUp();
  }

  Future<void> test_field_constructor_no_space() async {
    await assertDiagnostics(
      '''
class MyWidget {
  final String title;
  MyWidget(this.title);
}
''',
      [lint(41, 21)],
    );
  }

  Future<void> test_constructor_build_no_space() async {
    await assertDiagnostics(
      '''
class MyWidget {
  MyWidget();
  void build() {}
}
''',
      [lint(33, 15)],
    );
  }

  Future<void> test_field_constructor_with_space() async {
    await assertNoDiagnostics(
      '''
class MyWidget {
  final String title;

  MyWidget(this.title);
}
''',
    );
  }

  Future<void> test_constructor_build_with_space() async {
    await assertNoDiagnostics(
      '''
class MyWidget {
  MyWidget();

  void build() {}
}
''',
    );
  }

  Future<void> test_constructor_field_no_space() async {
    await assertDiagnostics(
      '''
class MyWidget {
  MyWidget();
  final String title = '';
}
''',
      [lint(33, 24)],
    );
  }

  Future<void> test_field_build_no_space() async {
    await assertDiagnostics(
      '''
class MyWidget {
  final String title = '';
  void build() {}
}
''',
      [lint(46, 15)],
    );
  }
}
