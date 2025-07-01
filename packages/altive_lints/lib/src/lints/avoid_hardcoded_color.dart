import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import '../utils/files_utils.dart';

/// An `avoid_hardcoded_color` rule that discourages the use of
/// hardcoded colors directly in the code, promoting the use of `ColorScheme`,
/// `ThemeExtension`, or other Theme-based systems for defining colors.
///
/// This practice ensures that colors are consistent and
/// adaptable to different themes and accessibility settings.
///
/// ### Example
///
/// #### BAD:
///
/// ```dart
/// Container(
///   color: Color(0xFF00FF00), // LINT
/// );
/// ```
///
/// #### GOOD:
///
/// ```dart
/// Container(
///   color: Theme.of(context).colorScheme.primary,
/// );
/// ```
class AvoidHardcodedColor extends DartLintRule {
  /// Creates a new instance of [AvoidHardcodedColor].
  const AvoidHardcodedColor() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_hardcoded_color',
    problemMessage: 'Avoid using hardcoded color. Use ColorScheme, '
        'ThemeExtension, or other Theme-based color definitions instead. '
        'Consider using Theme.of(context).colorScheme or a custom '
        'ThemeExtension for color definitions.',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    if (isTestFile(resolver.source)) {
      return;
    }
    context.registry.addInstanceCreationExpression((node) {
      if (_isInsideColorScheme(node)) {
        return;
      }
      final typeName = node.staticType?.getDisplayString();

      if (typeName == 'Color') {
        reporter.atNode(node, _code);
      }
    });

    context.registry.addPrefixedIdentifier((node) {
      final prefix = node.prefix.name;
      if (prefix == 'Colors') {
        final element = node.element;
        if (element is PropertyAccessorElement2) {
          final returnType = element.returnType;
          // Allow Colors.transparent as a valid hardcoded color, as it serves.
          if (node.identifier.name == 'transparent') {
            return;
          }
          if (_isColorType(returnType)) {
            reporter.atNode(node, _code);
          }
        }
      }
    });
  }

  bool _isColorType(DartType? type) {
    return type != null &&
        (type.isDartCoreInt ||
            type.getDisplayString() == 'Color' ||
            type.getDisplayString() == 'MaterialColor' ||
            type.getDisplayString() == 'MaterialAccentColor');
  }

  bool _isInsideColorScheme(AstNode node) {
    var parent = node.parent;
    while (parent != null) {
      if (parent is InstanceCreationExpression &&
          parent.staticType?.getDisplayString() == 'ColorScheme') {
        return true;
      }
      parent = parent.parent;
    }
    return false;
  }
}
