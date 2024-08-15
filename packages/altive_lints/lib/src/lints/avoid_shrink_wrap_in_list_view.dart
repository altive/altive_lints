import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/types_utils.dart';

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
class AvoidShrinkWrapInListView extends DartLintRule {
  const AvoidShrinkWrapInListView() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_shrink_wrap_in_list_view',
    problemMessage: 'Avoid using ListView with shrinkWrap, '
        'since it might degrade the performance.\n'
        'Consider using slivers instead. '
        'Or, it is originally intended to be used for shrinking '
        'when there is room for height in a dialog, for example.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (isListViewWidget(node.staticType) &&
          _hasShrinkWrap(node) &&
          _hasParentList(node)) {
        reporter.atNode(node, _code);
      }
    });
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
