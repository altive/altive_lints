import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template altive_lints_plugin.AvoidSingleChild}
/// An `avoid_single_child` rule that warns against using layout
/// widgets intended for multiple children with only one child.
///
/// This includes widgets like `Column`, `Row`, `Stack`, `Flex`, `Wrap`,
/// `ListView`, `SliverList`, `SliverMainAxisGroup`, and `SliverCrossAxisGroup`.
///
/// Using these widgets with a single child can lead to
/// unnecessary overhead and less efficient layouts.
/// Instead, consider using a widget more suited for single
/// children or adding more children to the widget.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// Column(
///   children: <Widget>[YourWidget()], // LINT
/// );
/// ```
///
/// #### GOOD:
///
/// ```dart
/// Center(child: YourWidget());
/// // or
/// Column(
///   children: <Widget>[YourWidget1(), YourWidget2()],
/// );
/// ```
/// {@endtemplate}
class AvoidSingleChild extends AnalysisRule {
  /// {@macro altive_lints_plugin.AvoidSingleChild}
  AvoidSingleChild()
    : super(name: _code.lowerCaseName, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_single_child',
    'Avoid using a single child in widgets that expect multiple children. '
        'Consider using a single child widget or adding more children.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final className = node.staticType?.getDisplayString();
    if ([
      'Column',
      'Row',
      'Flex',
      'Wrap',
      'Stack',
      'ListView',
      'SliverList',
      'SliverMainAxisGroup',
      'SliverCrossAxisGroup',
    ].contains(className)) {
      NamedArgument? childrenArg;
      for (final arg in node.argumentList.arguments) {
        if (arg is NamedArgument &&
            (arg.name.lexeme == 'children' || arg.name.lexeme == 'slivers')) {
          childrenArg = arg;
          break;
        }
      }

      final ListLiteral childrenList;
      if (childrenArg != null &&
          childrenArg.argumentExpression is ListLiteral) {
        childrenList = childrenArg.argumentExpression as ListLiteral;
      } else {
        return;
      }

      if (childrenList.elements.length != 1) {
        return;
      }
      for (final element in childrenList.elements) {
        if (element is IfElement) {
          if (_hasMultipleChild(element.thenElement)) {
            return;
          }

          if (element.elseElement case final CollectionElement ce
              when _hasMultipleChild(ce)) {
            return;
          }
        }
      }
      final element = childrenList.elements.first;
      if (element is ForElement) {
        return;
      }
      rule.reportAtNode(node);
    }
  }

  bool _hasMultipleChild(CollectionElement element) {
    if (element is SpreadElement && element.expression is ListLiteral) {
      final spreadElement = element.expression as ListLiteral;
      return spreadElement.elements.length > 1;
    }
    return false;
  }
}
