import 'package:altive_lints_plugin/src/lints/prefer_widget_class.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferWidgetClassTest);
  });
}

@reflectiveTest
class PreferWidgetClassTest extends AnalysisRuleTest {
  @override
  bool get addFlutterPackageDep => true;

  @override
  void setUp() {
    rule = PreferWidgetClass();
    super.setUp();
  }

  Future<void> test_method_explicit_widget() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Example {
  Widget makeWidget() => const Placeholder();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_method_inferred_subclass() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Example {
  makeWidget() => const Placeholder();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_method_nullable_widget() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Example {
  Widget? maybeWidget(bool show) => show ? const Placeholder() : null;
}
''';
    await assertDiagnostics(content, [
      lint(content.indexOf('maybeWidget'), 11),
    ]);
  }

  Future<void> test_top_level_function() async {
    const content = '''
import 'package:flutter/widgets.dart';

Widget makeWidget() => const Placeholder();
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_top_level_function_inferred() async {
    const content = '''
import 'package:flutter/widgets.dart';

makeWidget() => const Placeholder();
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_local_function_inferred() async {
    const content = '''
import 'package:flutter/widgets.dart';

void outer() {
  makeWidget() => const Placeholder();
  makeWidget();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_getters() async {
    const content = '''
import 'package:flutter/widgets.dart';

Widget get topWidget => const Placeholder();

class Example {
  Widget? get child => const Placeholder();
}
''';
    await assertDiagnostics(content, [
      lint(content.indexOf('topWidget'), 9),
      lint(content.indexOf('child'), 5),
    ]);
  }

  Future<void> test_getter_inferred() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Example {
  get child => const Placeholder();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('child'), 5)]);
  }

  Future<void> test_method_inferred_block_body() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Example {
  makeWidget(bool show) {
    if (show) return const Placeholder();
    return null;
  }
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('makeWidget'), 10)]);
  }

  Future<void> test_method_mixed_return_types() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class Example {
  mixed(bool show) {
    if (show) return const Placeholder();
    return 1;
  }
}
''');
  }

  Future<void> test_framework_build_methods() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => MyState();
}

class MyState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) => const Placeholder();
}
''');
  }

  Future<void> test_unrelated_build_method() async {
    const content = '''
import 'package:flutter/widgets.dart';

class Factory {
  Widget build() => const Placeholder();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('build'), 5)]);
  }

  Future<void> test_non_widget_and_closure() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

int count() => 1;
List<Widget> widgets() => [const Placeholder()];
final builder = () => const Placeholder();
''');
  }

  Future<void> test_unrelated_widget_named_type() async {
    await assertNoDiagnostics('''
class Widget {}
class Child extends Widget {}

Widget makeWidget() => Widget();
Child makeChild() => Child();
''');
  }

  Future<void> test_declarations_without_implementation() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

external Widget externalWidget();

abstract class Example {
  Widget makeWidget();
  external Widget get externalChild;
}
''');
  }
}
