import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:collection/collection.dart';

import '../utils/types_utils.dart';

/// {@template altive_lints.AvoidShrinkWrapInListView}
/// An `avoid_shrink_wrap_in_list_view` rule that discourages
/// using `shrinkWrap` with `ListView`.
///
/// This property causes performance issues by requiring
/// the list to fully layout its content upfront.
/// Instead of `shrinkWrap`, consider using slivers
/// for better performance with large lists.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// ListView(
///   shrinkWrap: true, // LINT
///   children: <Widget>[
///     Text('Hello'),
///     Text('World'),
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
///         Text('Hello'),
///         Text('World'),
///       ],
///     ),
///   ],
/// );
/// ```
/// {@endtemplate}
class AvoidShrinkWrapInListView extends AnalysisRule {
  /// {@macro altive_lints.AvoidShrinkWrapInListView}
  AvoidShrinkWrapInListView()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'avoid_shrink_wrap_in_list_view',
    'Avoid using ListView with shrinkWrap, '
        'since it might degrade the performance.\n'
        'Consider using slivers instead. '
        'Or, it is originally intended to be used for shrinking '
        'when there is room for height in a dialog, for example.',
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
    if (isListViewWidget(node.staticType) &&
        _hasShrinkWrap(node) &&
        _hasParentList(node)) {
      rule.reportAtNode(node);
    }
  }

  bool _hasShrinkWrap(InstanceCreationExpression node) =>
      node.argumentList.arguments.firstWhereOrNull(
        (arg) => arg is NamedExpression && arg.name.label.name == 'shrinkWrap',
      ) !=
      null;

  bool _hasParentList(InstanceCreationExpression node) =>
      node.thisOrAncestorMatching(
        (parent) =>
            parent != node &&
            parent is InstanceCreationExpression &&
            (isListViewWidget(parent.staticType) ||
                isColumnWidget(parent.staticType) ||
                isRowWidget(parent.staticType)),
      ) !=
      null;
}
