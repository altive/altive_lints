import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../utils/files_utils.dart';

/// {@template altive_lints.AvoidHardcodedJapanese}
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
/// {@endtemplate}
class AvoidHardcodedJapanese extends AnalysisRule {
  /// {@macro altive_lints.AvoidHardcodedJapanese}
  AvoidHardcodedJapanese()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_hardcoded_japanese',
    'This string appears to be untranslated to Japanese.\n'
        'Ensure all user-facing text is properly internationalized for '
        'Japanese localization.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addCompilationUnit(this, visitor);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  bool get _isTestFile => isTestFile(context.definingUnit.file);

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (_isTestFile) {
      super.visitSimpleStringLiteral(node);
      return;
    }
    final stringValue = node.stringValue;
    if (stringValue != null && _isJapanese(stringValue)) {
      rule.reportAtNode(node);
    }
    super.visitSimpleStringLiteral(node);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    if (_isTestFile) {
      super.visitStringInterpolation(node);
      return;
    }
    final stringValue = node.toSource();
    if (_isJapanese(stringValue)) {
      rule.reportAtNode(node);
    }
    super.visitStringInterpolation(node);
  }

  /// Checks if the string contains Japanese characters
  /// (Hiragana, Katakana, Kanji).
  bool _isJapanese(String value) =>
      RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FD0]').hasMatch(value);
}
