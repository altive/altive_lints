import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
class PreferToIncludeSliverInName extends DartLintRule {
  /// Creates a new instance of [PreferToIncludeSliverInName].
  const PreferToIncludeSliverInName() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_to_include_sliver_in_name',
    problemMessage: 'Widgets returning Sliver should include "Sliver" '
        'in the class name or named constructor.',
    correctionMessage:
        'Consider adding "Sliver" to the class name or a named constructor.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final methodBody = node.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((method) => method.name.lexeme == 'build')
          ?.body;

      if (methodBody is! BlockFunctionBody) {
        return;
      }

      final returnStatements =
          methodBody.block.statements.whereType<ReturnStatement>();
      final returnsSliverWidget = returnStatements.any(
        (returnStatement) {
          final returnType = returnStatement.expression?.staticType;
          final typeName = returnType?.getDisplayString();
          return typeName?.startsWith('Sliver') ?? false;
        },
      );

      final className = node.name.lexeme;
      final constructorNames = node.members
          .whereType<ConstructorDeclaration>()
          .map((constructor) => constructor.name?.lexeme)
          .whereType<String>();
      final hasSliverInClassOrConstructor = className.contains('Sliver') ||
          constructorNames.any(
            (constructorName) =>
                constructorName.toLowerCase().contains('sliver'),
          );

      if (returnsSliverWidget && !hasSliverInClassOrConstructor) {
        reporter.atNode(node, _code);
      }
    });
  }
}
