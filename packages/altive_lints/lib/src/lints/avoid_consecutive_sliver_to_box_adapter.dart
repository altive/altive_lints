import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template altive_lints.AvoidConsecutiveSliverToBoxAdapter}
/// A `avoid_consecutive_sliver_to_box_adapter` rule that
/// identifies and discourages the use of consecutive
/// `SliverToBoxAdapter` widgets within a list.
///
/// Consecutive usage of `SliverToBoxAdapter` can lead to
/// inefficient nesting and performance issues in scrollable areas.
///
/// It suggests using `SliverList.list` or similar consolidated
/// sliver widgets to optimize rendering performance and reduce
/// the complexity of the widget tree.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// CustomScrollView(
///   slivers: <Widget>[
///     SliverToBoxAdapter(child: Text('Item 1')), // Consecutive usage
///     SliverToBoxAdapter(child: Text('Item 2')), // LINT
///   ],
/// );
/// ```
///
/// #### GOOD:
///
/// ```dart
/// CustomScrollView(
///   slivers: <Widget>[
///     SliverList.list(
///       children: [
///         Text('Item 1')
///         Text('Item 2')
///       ],
///     ),
///   ],
/// );
/// ```
/// {@endtemplate}
class AvoidConsecutiveSliverToBoxAdapter extends AnalysisRule {
  /// {@macro altive_lints.AvoidConsecutiveSliverToBoxAdapter}
  AvoidConsecutiveSliverToBoxAdapter()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_consecutive_sliver_to_box_adapter',
    'Avoid using consecutive `SliverToBoxAdapter`. '
        'Consider using `SliverList.list` instead.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addListLiteral(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitListLiteral(ListLiteral node) {
    final iterator = node.elements.iterator;
    if (!iterator.moveNext()) {
      // if there are no elements, there is nothing to check.
      return;
    }

    var current = iterator.current;
    while (iterator.moveNext()) {
      final next = iterator.current;
      if (_useSliverToBoxAdapter(current) && _useSliverToBoxAdapter(next)) {
        rule.reportAtNode(node);
        return;
      }
      current = next;
    }
  }

  bool _useSliverToBoxAdapter(CollectionElement element) {
    if (element is! Expression) {
      return false;
    }
    return _isSliverToBoxAdapter(element) || _hasSliverToBoxAdapter(element);
  }

  bool _isSliverToBoxAdapter(Expression expression) {
    final typeName = expression.staticType?.getDisplayString();
    return typeName == 'SliverToBoxAdapter';
  }

  bool _hasSliverToBoxAdapter(Expression element) {
    if (element is! InstanceCreationExpression) {
      return false;
    }
    final constructor = element;
    final arguments = constructor.argumentList.arguments;
    for (final argument in arguments) {
      if (argument is NamedExpression && argument.name.label.name == 'sliver') {
        final sliverExpression = argument.expression;
        final sliverTypeName = sliverExpression.staticType?.getDisplayString();
        if (sliverTypeName == 'SliverToBoxAdapter') {
          return true;
        }
      }
    }
    return false;
  }
}
