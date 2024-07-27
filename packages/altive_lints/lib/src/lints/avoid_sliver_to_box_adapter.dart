import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// An `avoid_sliver_to_box_adapter` rule that discourages using
/// `SliverToBoxAdapter` due to performance inefficiencies.
///
/// This widget can lead to layout issues and increased
/// re-rendering in scrollable environments.
/// It's recommended to use`CustomScrollView` with `SliverList` or
/// other sliver widgets to optimize performance and ensure smoother scrolling.
///
/// See more here: https://api.flutter.dev/flutter/widgets/SliverToBoxAdapter-class.html
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverToBoxAdapter( // LINT
///       child: YourWidget()
///     ),
///   ],
/// );
/// ```
///
/// #### GOOD:
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverList.list(
///       children: [
///        YourWidget(),
///       ],
///     ),
///   ],
/// );
/// ```

class AvoidSliverToBoxAdapter extends DartLintRule {
  const AvoidSliverToBoxAdapter() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_sliver_to_box_adapter',
    problemMessage:
        'Avoid using `SliverToBoxAdapter` due to performance issues. '
        'Consider alternatives like `CustomScrollView` with `SliverList`.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final targetType =
          node.staticType?.getDisplayString(withNullability: false);
      if (targetType == 'SliverToBoxAdapter') {
        reporter.reportErrorForNode(_code, node);
      }
    });
  }
}
