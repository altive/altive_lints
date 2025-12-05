import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../utils/files_utils.dart';

/// {@template altive_lints.AvoidHardcodedColor}
/// An `avoid_hardcoded_color` rule that discourages the use of
/// hardcoded colors directly in the code, promoting the use of `ColorScheme`,
/// `ThemeExtension`, or other Theme-based systems for defining colors.
///
/// This practice ensures that colors are consistent and
/// adaptable to different themes and accessibility settings.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// Container(
///   color: Color(0xFF00FF00), // LINT
/// );
/// ```
///
/// #### GOOD:
///
/// ```dart
/// Container(
///   color: Theme.of(context).colorScheme.primary,
/// );
/// ```
/// {@endtemplate}
class AvoidHardcodedColor extends AnalysisRule {
  /// {@macro altive_lints.AvoidHardcodedColor}
  AvoidHardcodedColor()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_hardcoded_color',
    'Avoid using hardcoded color. Use ColorScheme based definitions.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry
      ..addInstanceCreationExpression(this, visitor)
      ..addMethodInvocation(this, visitor)
      ..addPrefixedIdentifier(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  bool get _isTestFile => isTestFile(context.definingUnit.file);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (_isTestFile || _isInsideColorScheme(node)) {
      return;
    }

    final type = node.staticType;
    if (_isColorClass(type?.element)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_isTestFile || _isInsideColorScheme(node)) {
      return;
    }

    final element = node.methodName.element;

    if (element is ConstructorElement) {
      if (_isColorClass(element.enclosingElement)) {
        rule.reportAtNode(node);
      }
      return;
    }

    // e.g. Color.fromARGB
    if (element is MethodElement && element.isStatic) {
      if (_isColorClass(element.enclosingElement)) {
        rule.reportAtNode(node);
      }
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (_isTestFile || _isInsideColorScheme(node)) {
      return;
    }

    final element = node.element;

    if (element is PropertyAccessorElement || element is FieldElement) {
      final parentClass = element?.enclosingElement;
      if (parentClass is ClassElement && parentClass.name == 'Colors') {
        // Colors.transparent is allowed
        if (node.identifier.name == 'transparent') {
          return;
        }

        final type = (element is PropertyAccessorElement)
            ? element.returnType
            : (element! as FieldElement).type;

        if (_isColorType(type)) {
          rule.reportAtNode(node);
        }
      }
    }
  }

  bool _isColorClass(Element? element) {
    if (element is! ClassElement) {
      return false;
    }
    return element.name == 'Color' ||
        element.name == 'MaterialColor' ||
        element.name == 'MaterialAccentColor';
  }

  bool _isColorType(DartType? type) {
    if (type == null) {
      return false;
    }
    if (type.isDartCoreInt) {
      return false;
    }
    return _isColorClass(type.element);
  }

  /// Checks if the node is defined inside a ColorScheme context.
  bool _isInsideColorScheme(AstNode node) {
    var parent = node.parent;
    while (parent != null) {
      // Check if we are inside a ColorScheme(...) constructor
      if (parent is InstanceCreationExpression) {
        final type = parent.staticType;
        if (type != null && type.element?.name == 'ColorScheme') {
          return true;
        }
      }

      // Check if we are inside a method call on a ColorScheme object
      if (parent is MethodInvocation) {
        final targetType = parent.target?.staticType;
        if (targetType != null && targetType.element?.name == 'ColorScheme') {
          return true;
        }

        final methodElement = parent.methodName.element;
        if (methodElement?.enclosingElement?.name == 'ColorScheme') {
          return true;
        }
      }
      parent = parent.parent;
    }
    return false;
  }
}
