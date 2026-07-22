import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template altive_lints_plugin.PreferClockNow}
/// A `prefer_clock_now` rule that discourages the use of
/// `DateTime.now()` and `DateTime.timestamp()` due to their non-testability in
/// unit tests.
///
/// Instead of these constructors, it recommends using a testable alternative,
/// such as `clock.now()` from the `clock` package or similar functions, which
/// allow for time manipulation in tests using methods like `withClock`.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// var now = DateTime.now(); // LINT
/// var timestamp = DateTime.timestamp(); // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// var now = clock.now(); // Using 'clock' package
/// ```
/// {@endtemplate}
class PreferClockNow extends AnalysisRule {
  /// {@macro altive_lints_plugin.PreferClockNow}
  PreferClockNow()
    : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The diagnostic code for this rule.
  static const code = LintCode(
    'prefer_clock_now',
    'Avoid using DateTime.now() or DateTime.timestamp(). '
        'Use a testable alternative like clock.now() or similar instead.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

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
    final type = node.staticType;
    if (type?.element?.name != 'DateTime' ||
        type?.element?.library?.isDartCore != true) {
      return;
    }

    final name = constructorName.name?.name;
    if (name == 'now' || name == 'timestamp') {
      rule.reportAtNode(node);
    }
  }
}
