import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A `prefer_sliver_prefix` rule that ensures widgets returning
/// a Sliver-type widget have a "Sliver" prefix in their class names.
///
/// This naming convention improves code readability and
/// consistency by clearly indicating the widget's functionality and
/// return type through its name.
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
class PreferSliverPrefix extends DartLintRule {
  const PreferSliverPrefix() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_sliver_prefix',
    problemMessage: 'Widgets returning Sliver should have a "Sliver" prefix.',
    correctionMessage: 'Consider adding "Sliver" prefix to the widget name.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final className = node.name.lexeme;
      final methodBody = node.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((method) => method.name.lexeme == 'build')
          ?.body;

      if (methodBody is BlockFunctionBody) {
        final returnStatements =
            methodBody.block.statements.whereType<ReturnStatement>();
        final returnsSliverWidget = returnStatements.any(
          (returnStatement) {
            final returnType = returnStatement.expression?.staticType;
            final typeName = returnType?.getDisplayString();
            return typeName?.startsWith('Sliver') ?? false;
          },
        );

        if (returnsSliverWidget && !className.startsWith('Sliver')) {
          reporter.atNode(node, _code);
        }
      }
    });
  }
}
