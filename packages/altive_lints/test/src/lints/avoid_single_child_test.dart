import 'package:altive_lints/src/lints/avoid_single_child.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidSingleChildTest);
  });
}

@reflectiveTest
class AvoidSingleChildTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = AvoidSingleChild();
    super.setUp();
  }

  Future<void> test_column_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Column(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 50)],
    );
  }

  Future<void> test_row_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Row(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 47)],
    );
  }

  Future<void> test_flex_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Flex(
    direction: Axis.horizontal,
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 80)],
    );
  }

  Future<void> test_wrap_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Wrap(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 48)],
    );
  }

  Future<void> test_stack_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Stack(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 49)],
    );
  }

  Future<void> test_listView_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  ListView(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 52)],
    );
  }

  Future<void> test_sliverList_single_sliver() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  SliverList(
    slivers: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 53)],
    );
  }

  Future<void> test_sliverList_list_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  SliverList.list(
    children: [
      Widget(),
    ],
  );
}
''',
      [lint(1252, 59)],
    );
  }

  Future<void> test_sliverMainAxisGroup_single_sliver() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  SliverMainAxisGroup(
    slivers: [
      SliverToBoxAdapter(child: Widget()),
    ],
  );
}
''',
      [lint(1252, 89)],
    );
  }

  Future<void> test_sliverCrossAxisGroup_single_sliver() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  SliverCrossAxisGroup(
    slivers: [
      SliverToBoxAdapter(child: Widget()),
    ],
  );
}
''',
      [lint(1252, 90)],
    );
  }

  Future<void> test_column_multiple_children() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  Column(
    children: [
      Widget(),
      Widget(),
    ],
  );
}
''',
    );
  }

  Future<void> test_column_if_single_child() async {
    await assertDiagnostics(
      '''
$widgetClasses
void f() {
  Column(
    children: [
      if (true) Widget(),
    ],
  );
}
''',
      [lint(1252, 60)],
    );
  }

  Future<void> test_column_if_spread_multiple_children() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  Column(
    children: [
      if (true) ...[Widget(), Widget()],
    ],
  );
}
''',
    );
  }

  Future<void> test_column_if_else_spread_multiple_children() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) Widget() else ...[Widget(), Widget()],
    ],
  );
}
''',
    );
  }

  Future<void> test_column_if_spread_single_else_spread_single() async {
    await assertDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) ...[
        Container(),
      ] else ...[
        Container(),
      ],
    ],
  );
}
''',
      [lint(1274, 129)],
    );
  }

  Future<void> test_column_if_spread_single_followed_by_child() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) ...[
        Container(),
      ],
      Container(),
    ],
  );
}
''',
    );
  }

  Future<void> test_column_if_single_spread_empty() async {
    await assertDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) ...[
        Container(),
      ],
    ],
  );
}
''',
      [lint(1274, 90)],
    );
  }

  Future<void> test_column_if_spread_multiple_single() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) ...[
        Container(),
        Container(),
      ],
    ],
  );
}
''',
    );
  }

  Future<void> test_column_if_spread_empty_else_spread_empty() async {
    await assertDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [if (condition) ...[] else ...[]],
  );
}
''',
      [lint(1274, 60)],
    );
  }

  Future<void> test_column_if_spread_empty_else_spread_single() async {
    await assertDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition)
        ...[]
      else ...[
        Container(),
      ]
    ],
  );
}
''',
      [lint(1274, 114)],
    );
  }

  Future<void> test_column_conditional_list_literals() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: condition
        ? [
            Text('Hello World'),
          ]
        : [
            Text('Hello'),
            Text('World'),
          ],
  );
}
''',
    );
  }

  Future<void> test_if_element_top_level() async {
    await assertDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition)
        Text('Hello World')
      else
        Column(
          children: [
            Text('Hello'),
            Text('World'),
          ],
        ),
    ],
  );
}
''',
      [lint(1274, 210)],
    );
  }

  Future<void> test_listView_list_generate() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  ListView(
    children: List.generate(
      10,
      (index) => Text('Hello'),
    ),
  );
}
''',
    );
  }

  Future<void> test_row_for_element() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  Row(
    children: [
      for (var i = 0; i < 10; i++) Text('Hello'),
    ],
  );
}
''',
    );
  }

  Future<void> test_sliverList_list_for_element() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  SliverList.list(
    children: [
      for (final e in ['a', 'b', 'c']) Text('Hello'),
    ],
  );
}
''',
    );
  }

  Future<void> test_sliverMainAxisGroup_multiple_slivers() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  SliverMainAxisGroup(
    slivers: [
      SliverAppBar(
        title: Text('Sliver App Bar'),
      ),
      SliverToBoxAdapter(
        child: Text('Hello World'),
      ),
    ],
  );
}
''',
    );
  }

  Future<void> test_column_multiple_ifs() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
var condition = true;
void f() {
  Column(
    children: [
      if (condition) Text('Hello 1'),
      if (condition) Text('Hello 2'),
    ],
  );
}
''',
    );
  }

  Future<void> test_column_empty_children() async {
    await assertNoDiagnostics(
      '''
$widgetClasses
void f() {
  Column(children: []);
}
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
class Flex extends Widget {
  const Flex({required Axis direction, List<Widget> children = const []});
}
class Wrap extends Widget {
  const Wrap({List<Widget> children = const []});
}
class Stack extends Widget {
  const Stack({List<Widget> children = const []});
}
class ListView extends Widget {
  const ListView({List<Widget> children = const []});
}
class SliverList extends Widget {
  const SliverList({List<Widget> slivers = const []});
  const SliverList.list({List<Widget> children = const []});
}
class SliverMainAxisGroup extends Widget {
  const SliverMainAxisGroup({List<Widget> slivers = const []});
}
class SliverCrossAxisGroup extends Widget {
  const SliverCrossAxisGroup({List<Widget> slivers = const []});
}
class SliverToBoxAdapter extends Widget {
  const SliverToBoxAdapter({Widget? child});
}
class SliverAppBar extends Widget {
  const SliverAppBar({Widget? title});
}
class Text extends Widget {
  const Text(String data);
}
class Container extends Widget {
  const Container();
}
enum Axis { horizontal, vertical }
''';
