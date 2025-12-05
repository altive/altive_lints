import 'dart:async';

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/assists/add_macro_document_comments.dart';
import 'src/assists/add_macro_template_document_comment.dart';
import 'src/assists/wrap_with_macro_template_document_comment.dart';
import 'src/lints/avoid_consecutive_sliver_to_box_adapter.dart';
import 'src/lints/avoid_hardcoded_color.dart';
import 'src/lints/avoid_hardcoded_japanese.dart';
import 'src/lints/avoid_shrink_wrap_in_list_view.dart';
import 'src/lints/avoid_single_child.dart';
import 'src/lints/prefer_clock_now.dart';
import 'src/lints/prefer_dedicated_media_query_methods.dart';
import 'src/lints/prefer_space_between_elements.dart';
import 'src/lints/prefer_to_include_sliver_in_name.dart';

/// Enables Altive lints.
final plugin = _Plugin();

class _Plugin extends Plugin {
  @override
  String get name => 'altive_lints';

  @override
  Future<void> register(PluginRegistry registry) async {
    registry
      ..registerLintRule(AvoidConsecutiveSliverToBoxAdapter())
      ..registerLintRule(AvoidHardcodedColor())
      ..registerLintRule(AvoidHardcodedJapanese())
      ..registerLintRule(AvoidShrinkWrapInListView())
      ..registerLintRule(AvoidSingleChild())
      ..registerLintRule(PreferClockNow())
      ..registerLintRule(PreferDedicatedMediaQueryMethods())
      ..registerLintRule(PreferSpaceBetweenElements())
      ..registerLintRule(PreferToIncludeSliverInName())
      ..registerAssist(AddMacroDocumentComment.new)
      ..registerAssist(AddMacroTemplateDocumentComment.new)
      ..registerAssist(WrapWithMacroTemplateDocumentComment.new)
    /* */;
  }
}
