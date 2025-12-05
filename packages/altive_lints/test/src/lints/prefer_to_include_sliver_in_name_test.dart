import 'package:altive_lints/src/lints/prefer_to_include_sliver_in_name.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferToIncludeSliverInNameTest);
  });
}

@reflectiveTest
class PreferToIncludeSliverInNameTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferToIncludeSliverInName();
    super.setUp();
  }

  Future<void> test_class_without_sliver_in_name_returns_sliver() async {
    await assertDiagnostics(
      '''
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Text('Item'),
    );
  }
}
$_widgetClasses
''',
      [lint(0, 209)],
    );
  }

  Future<void> test_class_with_sliver_in_name_returns_sliver() async {
    await assertNoDiagnostics('''
class MySliverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Text('Item'),
    );
  }
}
$_widgetClasses
''');
  }

  Future<void> test_class_without_sliver_returns_non_sliver() async {
    await assertNoDiagnostics('''
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Text('Item'),
    );
  }
}
$_widgetClasses
''');
  }
}

const _widgetClasses = '''
class BuildContext {}

class Widget {
  const Widget();
}

class StatelessWidget extends Widget {
  const StatelessWidget();
  Widget build(BuildContext context) => const Widget();
}

class SliverList extends Widget {
  const SliverList();
  const SliverList.builder({int? itemCount, Widget Function(BuildContext, int)? itemBuilder});
}

class ListView extends Widget {
  const ListView();
  const ListView.builder({int? itemCount, Widget Function(BuildContext, int)? itemBuilder});
}

class Text extends Widget {
  const Text(String data);
}
''';
