import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/avoid_hardcoded_japanese.dart';

PluginBase createPlugin() => _AltivePlugin();

class _AltivePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidHardcodedJapanese(),
      ];
}
