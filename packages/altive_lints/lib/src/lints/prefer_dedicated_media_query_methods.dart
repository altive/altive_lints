import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

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
class PreferDedicatedMediaQueryMethods extends AnalysisRule {
  /// Creates a new instance of [PreferDedicatedMediaQueryMethods].
  PreferDedicatedMediaQueryMethods()
    : super(name: _code.name, description: _code.problemMessage);

  static const _code = LintCode(
    'prefer_dedicated_media_query_methods',
    'Prefer using dedicated MediaQuery methods.',
    correctionMessage:
        'Consider using MediaQuery.sizeOf, widthOf, heightOf, etc. '
        'instead of accessing properties on generic methods.',
  );

  @override
  DiagnosticCode get diagnosticCode => _code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  _Visitor(this.rule, this.context);

  final AnalysisRule rule;
  final RuleContext context;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final method = node.methodName.name;
    final target = node.target?.toString();

    // Ignore if target is not MediaQuery
    if (target != 'MediaQuery') {
      return;
    }

    // Check for MediaQuery.of / maybeOf
    if (method == 'of' || method == 'maybeOf') {
      rule.reportAtNode(node);
      return;
    }

    // Check for MediaQuery.sizeOf(context).width / height
    if (method == 'sizeOf') {
      // Check if the parent node is a property access (.width or .height)
      final parent = node.parent;
      if (parent is PropertyAccess) {
        final propertyName = parent.propertyName.name;
        if (propertyName == 'width' || propertyName == 'height') {
          // Report on the entire expression including .width or .height
          rule.reportAtNode(parent);
        }
      }
    }
  }
}
