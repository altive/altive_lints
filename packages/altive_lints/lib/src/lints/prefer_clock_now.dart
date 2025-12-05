import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template altive_lints.PreferClockNow}
/// A `prefer_clock_now` rule that discourages the use of
/// `DateTime.now()` due to its non-testability in unit tests.
///
/// Instead of `DateTime.now()`, it recommends using a testable alternative,
/// such as `clock.now()` from the `clock` package or similar functions,
/// which allow for time manipulation in tests using methods like `withClock`.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// var now = DateTime.now(); // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// var now = clock.now(); // Using 'clock' package
/// ```
/// {@endtemplate}
class PreferClockNow extends AnalysisRule {
  /// {@macro altive_lints.PreferClockNow}
  PreferClockNow() : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'prefer_clock_now',
    'Avoid using DateTime.now(). '
        'Use a testable alternative like clock.now() or similar instead.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructorName = node.constructorName;
    final type = constructorName.type.name.lexeme;
    if (type != 'DateTime') {
      return;
    }
    if (node.constructorName.name?.name == 'now') {
      rule.reportAtNode(node);
    }
  }
}
