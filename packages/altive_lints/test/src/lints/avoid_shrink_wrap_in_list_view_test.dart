import 'package:altive_lints/src/lints/avoid_shrink_wrap_in_list_view.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidShrinkWrapInListViewTest);
  });
}

@reflectiveTest
class AvoidShrinkWrapInListViewTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = AvoidShrinkWrapInListView();
    super.setUp();
  }

  Future<void> test_listView_shrinkWrap_inside_listView() async {
    await assertDiagnostics(
      '''
void f() {
  ListView(
    children: [
      ListView(
        shrinkWrap: true,
        children: [],
      ),
    ],
  );
}
$widgetClasses
''',
      [lint(45, 65)],
    );
  }

  Future<void> test_listView_shrinkWrap_inside_column() async {
    await assertDiagnostics(
      '''
void f() {
  Column(
    children: [
      ListView(
        shrinkWrap: true,
        children: [],
      ),
    ],
  );
}
$widgetClasses
''',
      [lint(43, 65)],
    );
  }

  Future<void> test_listView_shrinkWrap_inside_row() async {
    await assertDiagnostics(
      '''
void f() {
  Row(
    children: [
      ListView(
        shrinkWrap: true,
        children: [],
      ),
    ],
  );
}
$widgetClasses
''',
      [lint(40, 65)],
    );
  }

  Future<void> test_listView_no_shrinkWrap() async {
    await assertNoDiagnostics(
      '''
void f() {
  ListView(
    children: [
      ListView(
        children: [],
      ),
    ],
  );
}
$widgetClasses
''',
    );
  }

  Future<void> test_listView_shrinkWrap_no_parent_list() async {
    await assertNoDiagnostics(
      '''
void f() {
  ListView(
    shrinkWrap: true,
    children: [],
  );
}
$widgetClasses
''',
    );
  }
}

const widgetClasses = '''
class Widget {
  const Widget();
}
class Column extends Widget {
  const Column({List<Widget> children = const []});
}
class Row extends Widget {
  const Row({List<Widget> children = const []});
}
class ListView extends Widget {
  const ListView({bool shrinkWrap = false, List<Widget> children = const []});
}
''';
