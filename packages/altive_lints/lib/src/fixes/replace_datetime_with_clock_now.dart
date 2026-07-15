import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';

/// Replaces an untestable `DateTime` constructor with `clock.now()`.
class ReplaceDateTimeWithClockNow extends ResolvedCorrectionProducer {
  /// Creates a fix producer for the diagnostic in [context].
  ReplaceDateTimeWithClockNow({required super.context});

  static final _clockUri = Uri.parse('package:clock/clock.dart');

  static const _kind = FixKind(
    'altive_lints.fix.replaceDateTimeWithClockNow',
    DartFixKindPriority.standard,
    "Replace with 'clock.now()'",
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final expression = node.thisOrAncestorOfType<InstanceCreationExpression>();
    if (expression == null) {
      return;
    }

    final type = expression.staticType;
    if (type?.element?.name != 'DateTime' ||
        type?.element?.library?.isDartCore != true) {
      return;
    }

    final constructorName = expression.constructorName.name?.name;
    if (constructorName != 'now' && constructorName != 'timestamp') {
      return;
    }

    // Do not offer a fix that would leave the target project with an
    // unresolved import. The lint remains useful even when package:clock is
    // not installed, because users can choose another testable clock.
    final clockLibrary = await unitResult.session.getLibraryByUri(
      _clockUri.toString(),
    );
    final clockElement = clockLibrary is LibraryElementResult
        ? clockLibrary.element.exportNamespace.get2('clock')
        : null;
    if (clockElement == null) {
      return;
    }

    await builder.addDartFileEdit(file, (builder) {
      builder.addReplacement(
        range.node(expression),
        (builder) {
          builder
            ..writeReference(clockElement)
            ..write('.now()');
          if (constructorName == 'timestamp') {
            builder.write('.toUtc()');
          }
        },
      );
    });
  }
}
