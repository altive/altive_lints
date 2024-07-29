import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/avoid_consecutive_sliver_to_box_adapter.dart';
import 'src/lints/avoid_hardcoded_japanese.dart';
import 'src/lints/avoid_shrink_wrap_in_list_view.dart';

PluginBase createPlugin() => _AltivePlugin();

class _AltivePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidHardcodedJapanese(),
        const AvoidShrinkWrapInListView(),
        const AvoidConsecutiveSliverToBoxAdapter(),
      ];
}
