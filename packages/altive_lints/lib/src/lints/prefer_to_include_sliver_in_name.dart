import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';

/// A `prefer_to_include_sliver_in_name` rule that ensures widgets returning
/// a Sliver-type widget include "Sliver" in their class names.
///
/// This naming convention improves code readability and consistency
/// by clearly indicating the widget's functionality
/// and return type through its name.
///
/// The rule also applies if "Sliver" is present in the named constructor,
/// allowing flexibility in how the convention is followed.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// class MyCustomList extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return SliverList(...); // LINT
///   }
/// }
/// ```
///
/// #### GOOD:
///
/// ```dart
/// class SliverMyCustomList extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return SliverList(...);
///   }
/// }
/// ```
class PreferToIncludeSliverInName extends AnalysisRule {
  /// Creates a new instance of [PreferToIncludeSliverInName].
  PreferToIncludeSliverInName()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'prefer_to_include_sliver_in_name',
    'Widgets returning Sliver should include "Sliver" '
        'in the class name or named constructor.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addClassDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final methodBody = node.members
        .whereType<MethodDeclaration>()
        .firstWhereOrNull((method) => method.name.lexeme == 'build')
        ?.body;

    if (methodBody is! BlockFunctionBody) {
      return;
    }

    final returnStatements = methodBody.block.statements
        .whereType<ReturnStatement>();
    final returnsSliverWidget = returnStatements.any(
      (returnStatement) {
        final returnType = returnStatement.expression?.staticType;
        final typeName = returnType?.getDisplayString();
        return typeName?.startsWith('Sliver') ?? false;
      },
    );

    if (!returnsSliverWidget) {
      return;
    }

    final className = node.name.lexeme;

    if (className.contains('Sliver')) {
      return;
    }

    final constructorNames = node.members
        .whereType<ConstructorDeclaration>()
        .map((constructor) => constructor.name?.lexeme)
        .nonNulls;

    final hasSliverInConstructor = constructorNames.any(
      (constructorName) => constructorName.toLowerCase().contains('sliver'),
    );

    if (hasSliverInConstructor) {
      return;
    }

    rule.reportAtNode(node);
  }
}
