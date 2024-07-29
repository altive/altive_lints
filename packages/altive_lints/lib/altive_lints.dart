import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/lints/avoid_hardcoded_color.dart';
import 'src/lints/avoid_hardcoded_japanese.dart';
import 'src/lints/avoid_shrink_wrap_in_list_view.dart';
import 'src/lints/avoid_single_child.dart';
import 'src/lints/prefer_clock_now.dart';

PluginBase createPlugin() => _AltivePlugin();

class _AltivePlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidHardcodedColor(),
        const AvoidHardcodedJapanese(),
        const AvoidShrinkWrapInListView(),
        const AvoidSingleChild(),
        const PreferClockNow(),
      ];
}
