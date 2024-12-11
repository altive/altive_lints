import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// {@template altive_lints.WrapWithMacroTemplateDocumentComment}
/// A Dart assist that wraps an existing documentation comment with a macro
/// template comment.
///
/// This assist helps in maintaining consistent documentation across the
/// codebase by ensuring that each documentation comment is wrapped with a
/// macro template, which can be used for generating documentation or for
/// other tooling purposes.
///
/// The macro template comment follows the format:
///
/// ```dart
/// /// {[@]template packageName.className}
/// /// Existing documentation comment.
/// /// {[@]endtemplate}
/// ```
///
/// Example usage:
///
/// Before:
/// ```dart
/// /// This is a class.
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// After running the assist:
/// ```dart
/// /// {[@]template my_package.MyClass}
/// /// This is a class.
/// /// {[@]endtemplate}
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// {@endtemplate}
class WrapWithMacroTemplateDocumentComment extends DartAssist {
  /// {@macro altive_lints.WrapWithMacroTemplateDocumentComment}
  WrapWithMacroTemplateDocumentComment();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addComment((node) {
      if (!target.intersects(node.sourceRange)) {
        return;
      }

      final currentComment = node.tokens.join();
      if (currentComment.contains('{@template') &&
          currentComment.contains('{@endtemplate}')) {
        return;
      }

      if (!node.isDocumentation) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Wrap with macro template documentation comment',
        priority: 20,
      );

      final packageName = context.pubspec.name;
      final classNode = node.parent;
      var className = '';
      if (classNode is ClassDeclaration) {
        className = classNode.name.lexeme;
      }

      final templateStart = '/// {@template $packageName.$className}';
      const templateEnd = '/// {@endtemplate}';

      changeBuilder.addDartFileEdit((builder) {
        builder
          ..addSimpleInsertion(node.offset, '$templateStart\n')
          ..addSimpleInsertion(node.end, '\n$templateEnd');
      });
    });
  }
}
