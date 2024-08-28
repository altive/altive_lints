import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A `prefer_space_between_elements` rule that enforces
/// spacing conventions within class definitions by requiring
/// a blank line between the constructor and fields,
/// and between the constructor and the build method.
///
/// Proper spacing enhances code readability and organization,
/// making it easier to visually distinguish between
/// different sections of a class.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   final String title;
///   MyWidget(this.title);
///   @override
///   Widget build(BuildContext context) {
///     return Text(title);
///   }
/// }
/// ```
///
/// #### GOOD:
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   final String title;
///
///   MyWidget(this.title);
///
///   @override
///   Widget build(BuildContext context) {
///     return Text(title);
///   }
/// }
/// ```
class PreferSpaceBetweenElements extends DartLintRule {
  /// Creates a new instance of [PreferSpaceBetweenElements].
  const PreferSpaceBetweenElements() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_space_between_elements',
    problemMessage:
        'Ensure there is a blank line between constructor and fields, '
        'and between constructor and build method.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final lineInfo = resolver.lineInfo;
      final members = node.members;
      for (var i = 0; i < members.length - 1; i++) {
        final currentMember = members[i];
        final nextMember = members[i + 1];

        // No blank line between constructor and build method.
        if (currentMember is ConstructorDeclaration &&
            nextMember is MethodDeclaration &&
            nextMember.name.lexeme == 'build') {
          if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
            reporter.atNode(nextMember, _code);
          }
        }

        // No blank line between fields and constructor.
        if (currentMember is FieldDeclaration &&
            nextMember is ConstructorDeclaration) {
          if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
            reporter.atNode(nextMember, _code);
          }
        }

        // No blank line between constructor and fields.
        if (currentMember is ConstructorDeclaration &&
            nextMember is FieldDeclaration) {
          if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
            reporter.atNode(nextMember, _code);
          }
        }

        // No blank line between constructor and fields.
        if (currentMember is FieldDeclaration &&
            nextMember is MethodDeclaration &&
            nextMember.name.lexeme == 'build') {
          if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
            reporter.atNode(nextMember, _code);
          }
        }
      }
    });
  }

  /// Returns `true` if there is a blank line between [first] and [second].
  bool _hasBlankLineBetween(AstNode first, AstNode second, LineInfo lineInfo) {
    final firstEndLine = lineInfo.getLocation(first.endToken.end).lineNumber;
    final secondStartLine =
        lineInfo.getLocation(second.beginToken.offset).lineNumber;
    return (secondStartLine - firstEndLine) > 1;
  }
}
