import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidHardcodedJapanese extends DartLintRule {
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
    context.registry.addSimpleStringLiteral((node) {
      final stringValue = node.stringValue;
      if (stringValue == null) {
        return;
      }
      if (isJapanese(stringValue)) {
        reporter.reportErrorForNode(_code, node);
      }
    });

    context.registry.addStringInterpolation((node) {
      final stringValue = node.toSource();
      if (isJapanese(stringValue)) {
        reporter.reportErrorForNode(_code, node);
      }
    });
  }

  // Checks if the string contains Japanese characters
  // (Hiragana, Katakana, Kanji).
  bool isJapanese(String value) =>
      RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FD0]').hasMatch(value);
}
