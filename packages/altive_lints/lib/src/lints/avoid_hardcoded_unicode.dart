import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/files_utils.dart';

/// An `avoid_hardcoded_unicode` rule which detects
/// and reports hardcoded string literals containing characters
/// outside a configurable ASCII range (default: 0x20-0x7E).
///
/// This rule ensures that all user-facing text is
/// properly internationalized and avoids hardcoded non-ASCII text.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// final message = 'こんにちは'; // LINT
/// print('Ошибка'); // LINT
/// print('¡Hola!'); // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// final message = AppLocalizations.of(context).hello;
/// print(AppLocalizations.of(context).errorOccurred);
/// ```
///
class AvoidHardcodedUnicode extends DartLintRule {
  /// Creates a new instance of [AvoidHardcodedUnicode].
  const AvoidHardcodedUnicode({
    this.allowedRangeStart = 0x20,
    this.allowedRangeEnd = 0x7E,
  }) : super(code: _code);

  final int allowedRangeStart;
  final int allowedRangeEnd;

  static const _code = LintCode(
    name: 'avoid_hardcoded_unicode',
    problemMessage: 'This string contains hardcoded non-ASCII (Unicode) characters.\n'
        'Ensure all user-facing text is properly internationalized.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isTestFile(resolver.source)) {
      return;
    }
    context.registry.addSimpleStringLiteral((node) {
      final stringValue = node.stringValue;
      if (stringValue == null) {
        return;
      }
      if (_containsDisallowedUnicode(stringValue)) {
        reporter.atNode(node, _code);
      }
    });

    context.registry.addStringInterpolation((node) {
      final stringValue = node.toSource();
      if (_containsDisallowedUnicode(stringValue)) {
        reporter.atNode(node, _code);
      }
    });
  }

  /// Checks if the string contains any character outside the allowed ASCII range.
  bool _containsDisallowedUnicode(String value) {
    for (final codeUnit in value.codeUnits) {
      if (codeUnit < allowedRangeStart || codeUnit > allowedRangeEnd) {
        // Allow common escape sequences (e.g., \n, \t)
        if (codeUnit == 0x0A || codeUnit == 0x0D || codeUnit == 0x09) continue;
        return true;
      }
    }
    return false;
  }
}
