import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:collection/collection.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// An `avoid_single_child` rule that warns against using layout
/// widgets intended for multiple children with only one child.
///
/// This includes widgets like `Column`, `Row`, `Stack`, `Flex`, `Wrap`
/// `ListView`, and `SliverList`.
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
class AvoidSingleChild extends DartLintRule {
  /// Creates a new instance of [AvoidSingleChild].
  const AvoidSingleChild() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_single_child',
    problemMessage:
        'Avoid using a single child in widgets that expect multiple children. '
        'Consider using a single child widget or adding more children.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final className = node.staticType?.getDisplayString();
      if ([
        'Column',
        'Row',
        'Flex',
        'Wrap',
        'Stack',
        'ListView',
        'SliverList',
      ].contains(className)) {
        final childrenArg = node.argumentList.arguments.firstWhereOrNull(
          (arg) => arg is NamedExpression && arg.name.label.name == 'children',
        );

        final ListLiteral childrenList;
        if (childrenArg is NamedExpression &&
            childrenArg.expression is ListLiteral) {
          childrenList = childrenArg.expression as ListLiteral;
        } else {
          return;
        }

        if (childrenList.elements.length != 1) {
          return;
        }

        final element = childrenList.elements.first;
        if (element is ForElement) {
          return;
        }
        reporter.atNode(node, _code);
      }
    });
  }
}
