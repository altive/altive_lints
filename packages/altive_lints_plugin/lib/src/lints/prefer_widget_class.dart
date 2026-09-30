import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

/// Warns when a function, method, or getter returns a Flutter widget.
///
/// Extracting the returned widget into a widget class gives it its own
/// element and makes its build scope explicit.
class PreferWidgetClass extends AnalysisRule {
  /// Creates the `prefer_widget_class` rule.
  PreferWidgetClass()
    : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'prefer_widget_class',
    'Prefer a widget class over a function or getter returning a widget.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry
      ..addFunctionDeclaration(this, visitor)
      ..addMethodDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule);

  final AnalysisRule rule;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (node.externalKeyword != null ||
        node.functionExpression.body is EmptyFunctionBody) {
      return;
    }

    final functionType = node.functionExpression.staticType;
    final returnType =
        node.declaredFragment?.element.returnType ??
        (functionType is FunctionType ? functionType.returnType : null);
    if (_isFlutterWidget(returnType) ||
        (node.returnType == null &&
            _returnsOnlyWidgets(node.functionExpression.body))) {
      rule.reportAtToken(node.name);
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.isAbstract ||
        node.externalKeyword != null ||
        _isFrameworkBuildMethod(node)) {
      return;
    }

    if (_isFlutterWidget(node.declaredFragment?.element.returnType) ||
        (node.returnType == null && _returnsOnlyWidgets(node.body))) {
      rule.reportAtToken(node.name);
    }
  }

  bool _isFrameworkBuildMethod(MethodDeclaration node) {
    if (node.name.lexeme != 'build' || node.isStatic || node.isGetter) {
      return false;
    }

    final declaration = node.thisOrAncestorOfType<ClassDeclaration>();
    final supertypes = declaration?.declaredFragment?.element.allSupertypes;
    return supertypes?.any(
          (type) =>
              _isFlutterFrameworkType(type, 'StatelessWidget') ||
              _isFlutterFrameworkType(type, 'State'),
        ) ??
        false;
  }
}

bool _returnsOnlyWidgets(FunctionBody body) {
  if (body is ExpressionFunctionBody) {
    return _isFlutterWidget(body.expression.staticType);
  }
  if (body is! BlockFunctionBody) {
    return false;
  }

  final collector = _ReturnCollector();
  body.block.accept(collector);
  return collector.hasWidget && collector.onlyWidgets;
}

class _ReturnCollector extends RecursiveAstVisitor<void> {
  bool hasWidget = false;
  bool onlyWidgets = true;

  @override
  void visitReturnStatement(ReturnStatement node) {
    final expression = node.expression;
    if (expression == null || expression is NullLiteral) {
      return;
    }
    if (_isFlutterWidget(expression.staticType)) {
      hasWidget = true;
    } else {
      onlyWidgets = false;
    }
  }

  @override
  void visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {}

  @override
  void visitFunctionExpression(FunctionExpression node) {}
}

bool _isFlutterWidget(DartType? type) =>
    type is InterfaceType &&
    [
      type,
      ...type.allSupertypes,
    ].any((candidate) => _isFlutterFrameworkType(candidate, 'Widget'));

bool _isFlutterFrameworkType(InterfaceType type, String name) =>
    type.element.name == name &&
    type.element.library.uri.toString() ==
        'package:flutter/src/widgets/framework.dart';
