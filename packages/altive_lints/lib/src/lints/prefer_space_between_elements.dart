import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/source/line_info.dart';

/// {@template altive_lints.PreferSpaceBetweenElements}
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
/// {@endtemplate}
class PreferSpaceBetweenElements extends AnalysisRule {
  /// {@macro altive_lints.PreferSpaceBetweenElements}
  PreferSpaceBetweenElements()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'prefer_space_between_elements',
    'Ensure there is a blank line between constructor and fields, '
        'and between constructor and build method.',
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
    final lineInfo = node.thisOrAncestorOfType<CompilationUnit>()?.lineInfo;
    if (lineInfo == null) {
      return;
    }
    final members = node.members;
    for (var i = 0; i < members.length - 1; i++) {
      final currentMember = members[i];
      final nextMember = members[i + 1];

      // No blank line between constructor and build method.
      if (currentMember is ConstructorDeclaration &&
          nextMember is MethodDeclaration &&
          nextMember.name.lexeme == 'build') {
        if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
          rule.reportAtNode(nextMember);
        }
      }

      // No blank line between fields and constructor.
      if (currentMember is FieldDeclaration &&
          nextMember is ConstructorDeclaration) {
        if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
          rule.reportAtNode(nextMember);
        }
      }

      // No blank line between constructor and fields.
      if (currentMember is ConstructorDeclaration &&
          nextMember is FieldDeclaration) {
        if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
          rule.reportAtNode(nextMember);
        }
      }

      // No blank line between fields and build method.
      if (currentMember is FieldDeclaration &&
          nextMember is MethodDeclaration &&
          nextMember.name.lexeme == 'build') {
        if (!_hasBlankLineBetween(currentMember, nextMember, lineInfo)) {
          rule.reportAtNode(nextMember);
        }
      }
    }
  }

  /// Returns `true` if there is a blank line between [first] and [second].
  bool _hasBlankLineBetween(AstNode first, AstNode second, LineInfo lineInfo) {
    final firstEndLine = lineInfo.getLocation(first.endToken.end).lineNumber;
    final secondStartLine = lineInfo
        .getLocation(second.beginToken.offset)
        .lineNumber;
    return (secondStartLine - firstEndLine) > 1;
  }
}
