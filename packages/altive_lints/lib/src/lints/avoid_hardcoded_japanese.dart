import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/files_utils.dart';

/// An `avoid_hardcoded_japanese` rule which detects
/// and reports hardcoded Japanese text strings within the code.
///
/// This rule ensures that all user-facing text is
/// properly internationalized to support Japanese localization efforts.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// final message = 'こんにちは'; // LINT
/// print('エラーが発生しました'); // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// final message = AppLocalizations.of(context).hello;
/// print(AppLocalizations.of(context).errorOccurred);
/// ```
///
class AvoidHardcodedJapanese extends DartLintRule {
  /// Creates a new instance of [AvoidHardcodedJapanese].
  const AvoidHardcodedJapanese() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_hardcoded_japanese',
    problemMessage: 'This string appears to be untranslated to Japanese.\n'
        'Ensure all user-facing text is properly internationalized for '
        'Japanese localization.',
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
      if (isJapanese(stringValue)) {
        reporter.atNode(node, _code);
      }
    });

    context.registry.addStringInterpolation((node) {
      final stringValue = node.toSource();
      if (isJapanese(stringValue)) {
        reporter.atNode(node, _code);
      }
    });
  }

  /// Checks if the string contains Japanese characters
  /// (Hiragana, Katakana, Kanji).
  bool isJapanese(String value) =>
      RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FD0]').hasMatch(value);
}
