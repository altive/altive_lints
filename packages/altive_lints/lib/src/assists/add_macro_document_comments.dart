import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// {@template altive_lints.AddMacroDocumentComment}
/// An assist to add macro template documentation comments to function
/// or constructor declarations.
///
/// This assist helps maintain consistent documentation across
/// the entire codebase by adding macro template comments
/// to each function or constructor. These comments can be used
/// for documentation generation or by other tools.
///
/// Macro template comments follow this format:
///
/// ```dart
/// /// {[@]macro packageName.functionName}
/// ```
///
/// Example:
///
/// Before:
/// ```dart
/// void myFunction() {
///   // Function implementation
/// }
/// ```
///
/// After applying the assist:
/// ```dart
/// /// {[@]macro my_package.myFunction}
/// void myFunction() {
///   // Function implementation
/// }
/// ```
///
/// {@endtemplate}
class AddMacroDocumentComment extends DartAssist {
  /// {@macro altive_lints.AddMacroDocumentComment}
  AddMacroDocumentComment();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addFunctionDeclaration((node) {
      _processNode(node, target, reporter, context);
    });

    context.registry.addConstructorDeclaration((node) {
      _processNode(node, target, reporter, context);
    });
  }

  void _processNode(
    AstNode node,
    SourceRange target,
    ChangeReporter reporter,
    CustomLintContext context,
  ) {
    if (!target.intersects(node.sourceRange)) {
      return;
    }

    final changeBuilder = reporter.createChangeBuilder(
      message: 'Add macro documentation comment',
      priority: 20,
    );

    final packageName = context.pubspec.name;
    var name = '';

    if (node is FunctionDeclaration) {
      name = node.name.lexeme;
    } else if (node is ConstructorDeclaration) {
      name = node.returnType.name;
    }

    final macroComment = '/// {@macro $packageName.$name}';

    changeBuilder.addDartFileEdit((builder) {
      builder.addSimpleInsertion(node.offset, '$macroComment\n');
    });
  }
}
