import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// {@template altive_lints.AddMacroTemplateDocumentComment}
/// A Dart assist that adds a macro template documentation comment to a class
/// declaration if it does not already have one.
///
/// This assist helps in maintaining consistent documentation across the
/// codebase by ensuring that each class has a macro template comment, which
/// can be used for generating documentation or for other tooling purposes.
///
/// The macro template comment follows the format:
///
/// ```dart
/// /// {[@]template packageName.className}
/// ///
/// /// {[@]endtemplate}
/// ```
///
/// Example usage:
///
/// Before:
/// ```dart
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// After running the assist:
/// ```dart
/// /// {[@]template my_package.MyClass}
/// ///
/// /// {[@]endtemplate}
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// {@endtemplate}
class AddMacroTemplateDocumentComment extends DartAssist {
  /// {@macro altive_lints.AddMacroTemplateDocumentComment}
  AddMacroTemplateDocumentComment();

  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addClassDeclaration((node) {
      if (!target.intersects(node.sourceRange)) {
        return;
      }

      final docComment = node.documentationComment;
      if (docComment != null) {
        return;
      }

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Add macro template documentation comment',
        priority: 20,
      );

      final packageName = context.pubspec.name;
      final className = node.name.lexeme;

      final template = [
        '/// {@template $packageName.$className}',
        '/// ',
        '/// {@endtemplate}',
      ].join('\n');

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(node.offset, '$template\n');
      });
    });
  }
}
