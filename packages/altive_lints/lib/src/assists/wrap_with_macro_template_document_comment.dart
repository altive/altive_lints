import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import '../utils/package_utils.dart';

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
/// /// {@template packageName.className}
/// /// Existing documentation comment.
/// /// {@endtemplate}
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
/// /// {@template my_package.MyClass}
/// /// This is a class.
/// /// {@endtemplate}
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// {@endtemplate}
class WrapWithMacroTemplateDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro altive_lints.WrapWithMacroTemplateDocumentComment}
  WrapWithMacroTemplateDocumentComment({required super.context});

  static const _kind = AssistKind(
    'dart.assist.wrapWithMacroTemplateDocumentComment',
    DartFixKindPriority.standard,
    'Wrap with a macro template documentation comment',
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  AssistKind get assistKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;

    // Locate the ancestor declaration (Class, Mixin, Enum, etc.)
    final declaration = node.thisOrAncestorOfType<NamedCompilationUnitMember>();
    if (declaration == null) {
      return;
    }

    // Get the documentation comment directly from the declaration
    final comment = declaration.documentationComment;
    if (comment == null) {
      return;
    }

    // Check cursor position validity
    // Allow execution if cursor is:
    // A) Inside the documentation comment
    // B) On the class/member name (UX improvement)
    final selectionInComment =
        selectionOffset >= comment.offset && selectionOffset <= comment.end;

    final nameToken = declaration.name;
    final selectionOnName =
        selectionOffset >= nameToken.offset && selectionOffset <= nameToken.end;

    if (!selectionInComment && !selectionOnName) {
      return;
    }

    // Prevent double wrapping
    for (final token in comment.tokens) {
      if (token.lexeme.contains('{@template')) {
        return;
      }
    }

    // --- Generation Logic ---

    final className = declaration.name.lexeme;

    final templateStart = '/// {@template $packageName.$className}';
    const templateEnd = '/// {@endtemplate}';

    await builder.addDartFileEdit(file, (builder) {
      builder
        // Insert header at the very beginning of the existing comment
        ..addSimpleInsertion(comment.offset, '$templateStart\n')
        // Insert footer at the very end of the existing comment
        ..addSimpleInsertion(comment.end, '\n$templateEnd');
    });
  }
}
