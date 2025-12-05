import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import '../utils/package_utils.dart';

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
/// /// {@macro packageName.functionName}
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
/// /// {@macro my_package.myFunction}
/// void myFunction() {
///   // Function implementation
/// }
/// ```
///
/// {@endtemplate}
class AddMacroDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro altive_lints.AddMacroDocumentComment}
  AddMacroDocumentComment({required super.context});

  static const _kind = AssistKind(
    'dart.assist.addMacroDocumentComment',
    DartFixKindPriority.standard,
    'Add a macro document comment',
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  AssistKind get assistKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;

    // Locate the ancestor ClassMember (covers both Methods and Constructors).
    final member = node.thisOrAncestorOfType<ClassMember>();

    if (member == null) {
      return;
    }

    // Extract necessary data using Dart 3 pattern matching.
    // This unifies the logic for MethodDeclaration and ConstructorDeclaration.
    final (
      String? nameSuffix,
      FunctionBody? body,
      Comment? existingDoc,
    ) = switch (member) {
      MethodDeclaration m => (m.name.lexeme, m.body, m.documentationComment),
      ConstructorDeclaration c => (
        c.name?.lexeme,
        c.body,
        c.documentationComment,
      ),
      // Ignore other class members like fields for now.
      _ => (null, null, null),
    };

    // If it's not a method or constructor, or if it already has docs, exit.
    if (body == null || existingDoc != null) {
      return;
    }

    // Validate cursor position. Ensure the cursor is strictly before the body
    // starts (on the signature line).
    if (selectionOffset >= body.offset) {
      return;
    }

    final classDeclaration = member.thisOrAncestorOfType<ClassDeclaration>();
    if (classDeclaration == null) {
      return;
    }

    // --- Generation Logic ---

    final className = classDeclaration.name.lexeme;

    var macroReference = '$packageName.$className';
    if (nameSuffix != null && nameSuffix.isNotEmpty) {
      macroReference += '.$nameSuffix';
    }

    final macroComment = '/// {@macro $macroReference}';

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(member.offset, '$macroComment\n');
    });
  }
}
