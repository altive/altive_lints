import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A `prefer_dedicated_media_query_methods` rule that encourages
/// the use of dedicated `MediaQuery` methods instead of
/// the generic `MediaQuery.of` or `MediaQuery.maybeOf`.
///
/// Using specialized methods like `MediaQuery.sizeOf` or
/// `MediaQuery.viewInsetsOf` improves performance by reducing
/// unnecessary widget rebuilds.
///
/// These methods directly access specific properties,
/// avoiding the overhead associated with the broader
/// context changes that trigger when using `MediaQuery.of`.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// var size = MediaQuery.of(context).size; // LINT
/// var padding = MediaQuery.maybeOf(context)?.padding; // LINT
/// ```
///
/// #### GOOD:
///
/// ```dart
/// var size = MediaQuery.sizeOf(context);
/// var padding = MediaQuery.viewInsetsOf(context);
/// ```
class PreferDedicatedMediaQueryMethods extends DartLintRule {
  const PreferDedicatedMediaQueryMethods() : super(code: _code);

  static const _code = LintCode(
    name: 'prefer_dedicated_media_query_methods',
    problemMessage: 'Prefer using dedicated MediaQuery methods instead of '
        'MediaQuery.of or MediaQuery.maybeOf.',
    correctionMessage: 'Consider using methods like MediaQuery.sizeOf or '
        'MediaQuery.viewInsetsOf.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final method = node.methodName.name;
      final target = node.target?.toString();
      if (target == 'MediaQuery' && (method == 'of' || method == 'maybeOf')) {
        reporter.atNode(node, _code);
      }
    });
  }
}
