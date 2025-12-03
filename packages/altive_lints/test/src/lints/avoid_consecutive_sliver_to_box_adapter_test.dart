import 'package:altive_lints/src/lints/avoid_consecutive_sliver_to_box_adapter.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidConsecutiveSliverToBoxAdapterTest);
  });
}

@reflectiveTest
class AvoidConsecutiveSliverToBoxAdapterTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = AvoidConsecutiveSliverToBoxAdapter();
    super.setUp();
  }

  Future<void> test_consecutive_sliver_to_box_adapter() async {
    await assertDiagnostics(
      '''
void f() {
  CustomScrollView(
    slivers: <Widget>[
      SliverToBoxAdapter(child: Text('Item 1')),
      SliverToBoxAdapter(child: Text('Item 2')),
    ],
  );
}
$widgetClasses
''',
      [lint(44, 113)],
    );
  }

  Future<void> test_no_consecutive_sliver_to_box_adapter() async {
    await assertNoDiagnostics('''
void f() {
  CustomScrollView(
    slivers: <Widget>[
      SliverToBoxAdapter(child: Text('Item 1')),
      SliverList.list(
        children: [
          Text('Item 2'),
        ],
      ),
    ],
  );
}
$widgetClasses
''');
  }

  Future<void> test_single_sliver_to_box_adapter() async {
    await assertNoDiagnostics('''
void f() {
  CustomScrollView(
    slivers: <Widget>[
      SliverToBoxAdapter(child: Text('Item 1')),
    ],
  );
}
$widgetClasses
''');
  }

  Future<void> test_empty_list() async {
    await assertNoDiagnostics('''
void f() {
  CustomScrollView(
    slivers: <Widget>[],
  );
}
$widgetClasses
''');
  }
}

const widgetClasses = '''
class Widget {
  const Widget();
}

class Text extends Widget {
  const Text(String text);
}

class SliverToBoxAdapter extends Widget {
  const SliverToBoxAdapter({Widget? child});
}

class SliverList extends Widget {
  const SliverList();
  static SliverList list({List<Widget>? children}) => SliverList();
}

class CustomScrollView extends Widget {
  const CustomScrollView({List<Widget>? slivers});
}
''';
