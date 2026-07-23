import 'package:altive_lints_plugin/src/fixes/replace_datetime_with_clock_now.dart';
import 'package:altive_lints_plugin/src/lints/prefer_clock_now.dart';
import 'package:analysis_server_plugin/edit/fix/dart_fix_context.dart';
import 'package:analysis_server_plugin/src/correction/dart_change_workspace.dart';
import 'package:analysis_server_plugin/src/correction/fix_generators.dart';
import 'package:analysis_server_plugin/src/correction/fix_processor.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/instrumentation/service.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferClockNowTest);
    defineReflectiveTests(PreferClockNowWithoutClockTest);
  });
}

@reflectiveTest
class PreferClockNowTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferClockNow();
    newPackage('clock').addFile('lib/clock.dart', '''
class Clock {
  DateTime now() => DateTime.now();
}

final clock = Clock();
''');
    super.setUp();

    // analyzer_testing's mock SDK does not yet declare these DateTime APIs, so
    // keep its surface aligned with the supported SDK.
    final coreFile = getFile('/sdk/lib/core/core.dart');
    final coreContent = coreFile.readAsStringSync();
    newFile(
      coreFile.path,
      coreContent.replaceFirst('DateTime.now() : this._now();', '''
DateTime.now() : this._now();
  DateTime.timestamp() : this._now();
  external DateTime toUtc();'''),
    );

    registeredFixGenerators.registerFixForLint(
      PreferClockNow.code,
      ReplaceDateTimeWithClockNow.new,
    );
  }

  @override
  Future<void> tearDown() async {
    registeredFixGenerators.clearLintProducers();
    await super.tearDown();
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

  Future<void> test_has_datetime_timestamp() async {
    await assertDiagnostics(
      '''
void f() {
  DateTime.timestamp();
}
''',
      [lint(13, 20)],
    );
  }

  Future<void> test_fix_datetime_now() async {
    const content = '''
void f() {
  final now = DateTime.now();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('DateTime'), 14)]);

    final fixed = await _applyFix(content);

    expect(fixed, '''
import 'package:clock/clock.dart';

void f() {
  final now = clock.now();
}
''');
  }

  Future<void> test_fix_datetime_timestamp() async {
    const content = '''
void f() {
  final timestamp = DateTime.timestamp();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('DateTime'), 20)]);

    final fixed = await _applyFix(content);

    expect(fixed, '''
import 'package:clock/clock.dart';

void f() {
  final timestamp = clock.now().toUtc();
}
''');
  }

  Future<void> test_fix_datetime_now_preserves_to_utc() async {
    const content = '''
void f() {
  final timestamp = DateTime.now().toUtc();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('DateTime'), 14)]);

    final fixed = await _applyFix(content);

    expect(fixed, '''
import 'package:clock/clock.dart';

void f() {
  final timestamp = clock.now().toUtc();
}
''');
  }

  Future<void> test_fix_uses_existing_import_prefix() async {
    const content = '''
import 'package:clock/clock.dart' as time;

final existingClock = time.clock;

void f() {
  final now = DateTime.now();
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('DateTime'), 14)]);

    final fixed = await _applyFix(content);

    expect(fixed, '''
import 'package:clock/clock.dart' as time;

final existingClock = time.clock;

void f() {
  final now = time.clock.now();
}
''');
  }

  Future<void> test_fix_uses_prefix_when_clock_is_shadowed() async {
    const content = '''
void f() {
  final clock = Object();
  final now = DateTime.now();
  print(clock);
}
''';
    await assertDiagnostics(content, [lint(content.indexOf('DateTime'), 14)]);

    final fixed = await _applyFix(content);

    expect(fixed, '''
import 'package:clock/clock.dart' as clock_package;

void f() {
  final clock = Object();
  final now = clock_package.clock.now();
  print(clock);
}
''');
  }

  Future<void> test_no_custom_datetime_now() async {
    await assertNoDiagnostics('''
class DateTime {
  DateTime.now();
}
void f() {
  DateTime.now();
}
''');
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

  Future<String> _applyFix(String content) async {
    final diagnostic = result.diagnostics.singleWhere(
      (diagnostic) => diagnostic.diagnosticCode == PreferClockNow.code,
    );
    final libraryResult = await result.session.getResolvedLibraryContaining(
      result.path,
    );
    final fixes = await computeFixes(
      DartFixContext(
        instrumentationService: InstrumentationService.NULL_SERVICE,
        workspace: DartChangeWorkspace([result.session]),
        libraryResult: libraryResult as ResolvedLibraryResult,
        unitResult: result,
        error: diagnostic,
      ),
    );
    final fix = fixes.singleWhere(
      (fix) =>
          fix.change.id ==
          'altive_lints_plugin.fix.replaceDateTimeWithClockNow',
    );
    final fileEdit = fix.change.edits.singleWhere(
      (edit) => edit.file == testFile.path,
    );
    return SourceEdit.applySequence(content, fileEdit.edits);
  }
}

@reflectiveTest
class PreferClockNowWithoutClockTest extends AnalysisRuleTest {
  @override
  void setUp() {
    rule = PreferClockNow();
    super.setUp();
    registeredFixGenerators.registerFixForLint(
      PreferClockNow.code,
      ReplaceDateTimeWithClockNow.new,
    );
  }

  @override
  Future<void> tearDown() async {
    registeredFixGenerators.clearLintProducers();
    await super.tearDown();
  }

  Future<void> test_no_fix_without_clock_dependency() async {
    const content = '''
void f() {
  DateTime.now();
}
''';
    await assertDiagnostics(content, [lint(13, 14)]);
    final diagnostic = result.diagnostics.singleWhere(
      (diagnostic) => diagnostic.diagnosticCode == PreferClockNow.code,
    );
    final libraryResult = await result.session.getResolvedLibraryContaining(
      result.path,
    );

    final fixes = await computeFixes(
      DartFixContext(
        instrumentationService: InstrumentationService.NULL_SERVICE,
        workspace: DartChangeWorkspace([result.session]),
        libraryResult: libraryResult as ResolvedLibraryResult,
        unitResult: result,
        error: diagnostic,
      ),
    );

    expect(
      fixes.where(
        (fix) =>
            fix.change.id ==
            'altive_lints_plugin.fix.replaceDateTimeWithClockNow',
      ),
      isEmpty,
    );
  }
}
