import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/types_utils.dart';

class AvoidShrinkWrapInListView extends DartLintRule {
  const AvoidShrinkWrapInListView() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_shrink_wrap_in_list_view',
    problemMessage: 'Avoid using ListView with shrinkWrap, '
        'since it might degrade the performance.\n'
        'Consider using slivers instead.',
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
        reporter.reportErrorForNode(_code, node);
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
