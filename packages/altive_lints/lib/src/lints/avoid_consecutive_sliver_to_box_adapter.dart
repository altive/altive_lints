import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

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
class AvoidConsecutiveSliverToBoxAdapter extends DartLintRule {
  /// Creates a new instance of [AvoidConsecutiveSliverToBoxAdapter].
  const AvoidConsecutiveSliverToBoxAdapter() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_consecutive_sliver_to_box_adapter',
    problemMessage: 'Avoid using consecutive `SliverToBoxAdapter`. '
        'Consider using `SliverList.list` instead.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addListLiteral((node) {
      final iterator = node.elements.iterator;
      if (!iterator.moveNext()) {
        // if there are no elements, there is nothing to check.
        return;
      }

      var current = iterator.current;
      while (iterator.moveNext()) {
        final next = iterator.current;
        if (_useSliverToBoxAdapter(current) && _useSliverToBoxAdapter(next)) {
          reporter.atNode(node, _code);
          return;
        }
        current = next;
      }
    });
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
