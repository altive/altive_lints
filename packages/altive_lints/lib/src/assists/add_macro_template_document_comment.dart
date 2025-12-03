import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import '../utils/package_utils.dart';

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
/// /// {@template packageName.className}
/// ///
/// /// {@endtemplate}
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
/// /// {@template my_package.MyClass}
/// ///
/// /// {@endtemplate}
/// class MyClass {
///   // Class implementation
/// }
/// ```
///
/// {@endtemplate}
class AddMacroTemplateDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro altive_lints.AddMacroTemplateDocumentComment}
  AddMacroTemplateDocumentComment({required super.context});

  static const _kind = AssistKind(
    'dart.assist.addMacroTemplateDocumentComment',
    DartFixKindPriority.standard,
    'Add a macro template documentation comment',
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

    // Check for existing docs.
    if (declaration.documentationComment != null) {
      return;
    }

    // Validate cursor position (Must be on the name).
    final nameToken = declaration.name;

    // Check if cursor is strictly within the name token range.
    if (selectionOffset < nameToken.offset || selectionOffset > nameToken.end) {
      return;
    }

    // --- Generation Logic ---

    final name = nameToken.lexeme;

    final template = [
      '/// {@template $packageName.$name}',
      '/// ',
      '/// {@endtemplate}',
    ].join('\n');

    await builder.addDartFileEdit(file, (builder) {
      // Insert at the very beginning of the declaration (before annotations),
      //       not at the cursor position (node.offset).
      builder.addSimpleInsertion(declaration.offset, '$template\n');
    });
  }
}
