import 'package:altive_lints/src/lints/prefer_dedicated_media_query_methods.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferDedicatedMediaQueryMethodsTest);
  });
}

@reflectiveTest
class PreferDedicatedMediaQueryMethodsTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferDedicatedMediaQueryMethods();
    super.setUp();
  }

  Future<void> test_mediaQuery_of() async {
    await assertDiagnostics(
      '''
void f(BuildContext context) {
  MediaQuery.of(context);
}
$mockClasses
''',
      [lint(33, 22)],
    );
  }

  Future<void> test_mediaQuery_maybeOf() async {
    await assertDiagnostics(
      '''
void f(BuildContext context) {
  MediaQuery.maybeOf(context);
}
$mockClasses
''',
      [lint(33, 27)],
    );
  }

  Future<void> test_mediaQuery_sizeOf() async {
    await assertNoDiagnostics(
      '''
void f(BuildContext context) {
  MediaQuery.sizeOf(context);
}
$mockClasses
''',
    );
  }

  Future<void> test_mediaQuery_viewInsetsOf() async {
    await assertNoDiagnostics(
      '''
void f(BuildContext context) {
  MediaQuery.viewInsetsOf(context);
}
$mockClasses
''',
    );
  }

  Future<void> test_mediaQuery_of_property_access() async {
    await assertDiagnostics(
      '''
void f(BuildContext context) {
  var size = MediaQuery.of(context).size;
}
$mockClasses
''',
      [lint(44, 22)],
    );
  }

  Future<void> test_mediaQuery_sizeOf_width() async {
    await assertDiagnostics(
      '''
void f(BuildContext context) {
  var width = MediaQuery.sizeOf(context).width;
}
$mockClasses
''',
      [lint(45, 32)],
    );
  }

  Future<void> test_mediaQuery_sizeOf_height() async {
    await assertDiagnostics(
      '''
void f(BuildContext context) {
  var height = MediaQuery.sizeOf(context).height;
}
$mockClasses
''',
      [lint(46, 33)],
    );
  }
}

const mockClasses = '''
class BuildContext {}

class MediaQuery {
  static MediaQueryData of(BuildContext context) => MediaQueryData();
  static MediaQueryData? maybeOf(BuildContext context) => MediaQueryData();
  static Size sizeOf(BuildContext context) => Size();
  static EdgeInsets viewInsetsOf(BuildContext context) => EdgeInsets();
}

class MediaQueryData {
  Size get size => Size();
  EdgeInsets get padding => EdgeInsets();
}

class Size {
  double get width => 0;
  double get height => 0;
}
class EdgeInsets {}
''';
