import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/avoid_consecutive_sliver_to_box_adapter.dart';
import 'src/lints/avoid_hardcoded_color.dart';
import 'src/lints/avoid_hardcoded_japanese.dart';
import 'src/lints/avoid_shrink_wrap_in_list_view.dart';
import 'src/lints/avoid_single_child.dart';
import 'src/lints/prefer_clock_now.dart';
import 'src/lints/prefer_dedicated_media_query_methods.dart';
import 'src/lints/prefer_space_between_elements.dart';
import 'src/lints/prefer_to_include_sliver_in_name.dart';

/// Returns the Altive Plugin instance.
PluginBase createPlugin() => _AltivePlugin();

class _AltivePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidConsecutiveSliverToBoxAdapter(),
        const AvoidHardcodedColor(),
        const AvoidHardcodedJapanese(),
        const AvoidShrinkWrapInListView(),
        const AvoidSingleChild(),
        const PreferClockNow(),
        const PreferDedicatedMediaQueryMethods(),
        const PreferSpaceBetweenElements(),
        const PreferToIncludeSliverInName(),
      ];
}
