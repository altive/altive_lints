import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A `prefer_clock_now` rule that discourages the use of
/// `DateTime.now()` due to its non-testability in unit tests.
///
/// Instead of `DateTime.now()`, it recommends using a testable alternative,
/// such as `clock.now()` from the `clock` package or similar functions,
/// which allow for time manipulation in tests using methods like `withClock`.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// var now = DateTime.now(); // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// var now = clock.now(); // Using 'clock' package
/// ```
class PreferClockNow extends DartLintRule {
  const PreferClockNow() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_clock_now',
    problemMessage: 'Avoid using DateTime.now(). '
        'Use a testable alternative like clock.now() or similar instead.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final constructorName = node.constructorName;
      final type = constructorName.type.name2.lexeme;
      if (type != 'DateTime') {
        return;
      }
      if (node.constructorName.name?.name == 'now') {
        reporter.reportErrorForNode(_code, node);
      }
    });
  }
}
