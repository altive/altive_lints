## 1.22.1

 - bump custom_lint_builder to 0.8.0 (thanks to @masa-tokyo)

## 1.22.0

 - **FEAT**: Update all lint rules (#105).
   - Added
     - [switch_on_type](https://dart.dev/tools/linter-rules/switch_on_type)
     - [unnecessary_unawaited](https://dart.dev/tools/linter-rules/unnecessary_unawaited)
 - **FEAT**: update avoid_single_child lint to include SliverMainAxisGroup and SliverCrossAxisGroup (#103).
 - Update the minimum Dart SDK version to 3.5.0. (using pub_workspace and Melos v7)

## 1.21.0

 - **FIX**: disable `omit_obvious_property_types` and `unsafe_variance` ([#101](https://github.com/altive/altive_lints/issues/101)). ([68727270](https://github.com/altive/altive_lints/commit/68727270dbb8979ea2476e66a8c4ed6fa6d7f0e5))
 - **FEAT**: preserve trailing_commas ([#102](https://github.com/altive/altive_lints/issues/102)). ([12d05633](https://github.com/altive/altive_lints/commit/12d05633e21a1a117e52122c6220288d5218697f))

## 1.20.0

 - **FEAT**: update all_lint_rules ([#97](https://github.com/altive/altive_lints/issues/97)). ([cefae16b](https://github.com/altive/altive_lints/commit/cefae16b2abb231497e5c0e1b25615854e0028a7))
   - Added
     - [unnecessary_ignore](https://dart.dev/tools/linter-rules/unnecessary_ignore)
     - [use_null_aware_elements](https://dart.dev/tools/linter-rules/use_null_aware_elements)
 - **FEAT**: update all_lint_rules ([#94](https://github.com/altive/altive_lints/issues/94)). ([4291b32d](https://github.com/altive/altive_lints/commit/4291b32d7909e45491edd981b141c495f80b11dd))
   - Removed
     - [unnecessary_ignore](https://dart.dev/tools/linter-rules/unnecessary_ignore)

## 1.19.1

 - **FIX**: disable unnecessary_async lint rule to resolve conflicts with other lint patterns ([#92](https://github.com/altive/altive_lints/issues/92)). ([72c9323a](https://github.com/altive/altive_lints/commit/72c9323aaf049836f46073866aee539fb819ff8a))
 - **FIX**: remove todo and fixme ignore settings from altive_lints.yaml ([#89](https://github.com/altive/altive_lints/issues/89)). ([2b2d7c3a](https://github.com/altive/altive_lints/commit/2b2d7c3aa94fe58feef5ad22ae51b4095ae8f8a5))

## 1.19.0

 - **FEAT**: update all_lint_rules ([#87](https://github.com/altive/altive_lints/issues/87)). ([a8fb7593](https://github.com/altive/altive_lints/commit/a8fb7593f0721daf323f70744b5b902be5af1db0))
   - Added
     - [omit_obvious_property_types](https://dart.dev/tools/linter-rules/omit_obvious_property_types)
     - [specify_nonobvious_property_types](https://dart.dev/tools/linter-rules/specify_nonobvious_property_types)
     - [strict_top_level_inference](https://dart.dev/tools/linter-rules/strict_top_level_inference)
     - [unnecessary_async](https://dart.dev/tools/linter-rules/unnecessary_async)
     - [unnecessary_ignore](https://dart.dev/tools/linter-rules/unnecessary_ignore)
     - [unnecessary_underscores](https://dart.dev/tools/linter-rules/unnecessary_underscores)
     - [unsafe_variance](https://dart.dev/tools/linter-rules/unsafe_variance)
   - Removed
     - [package_api_docs](https://dart.dev/tools/linter-rules/package_api_docs)

## 1.18.0

 - **FEAT**: disable avoid_hardcoded_color lint if it's a test file ([#83](https://github.com/altive/altive_lints/issues/83)). ([6003c83f](https://github.com/altive/altive_lints/commit/6003c83f929a8e402dbda83bc519437567adfc75))
 - **FEAT**: Add assists for macro documentation comments ([#78](https://github.com/altive/altive_lints/issues/78)). ([8126ddc0](https://github.com/altive/altive_lints/commit/8126ddc0ed0ec97b98c43ab565efa738cfb9e7d4))

## 1.17.0

 - **FEAT**: Disable specify_nonobvious_local_variable_types to avoid conflicts ([#80](https://github.com/altive/altive_lints/issues/80)). ([cc54fcc3](https://github.com/altive/altive_lints/commit/cc54fcc35efc7620f5e12ebb82c9ee328d5c95db))

## 1.16.0

 - **FIX**: No warning if the number of elements in the spread operator using the if statement is more than two. ([#74](https://github.com/altive/altive_lints/issues/74)). ([ad65c006](https://github.com/altive/altive_lints/commit/ad65c00659977b511ef4f6b0dbf9c72647953584)) for `avoid_single_child`.
 - **FIX**: Resolved warnings false detection in ColorScheme definition ([#73](https://github.com/altive/altive_lints/issues/73)). ([4dc4b4e6](https://github.com/altive/altive_lints/commit/4dc4b4e6c264d018bd5bdbb353af0ec02a8cd8da)) for `avoid_hardcoded_color`.
 - **FEAT**: update all_lint_rules ([#76](https://github.com/altive/altive_lints/issues/76)). ([de9ac8ca](https://github.com/altive/altive_lints/commit/de9ac8ca0de01b925167713ad42beeb747a0c147))
   - Added
     - [avoid_futureor_void](https://dart.dev/tools/linter-rules/avoid_futureor_void)
     - [avoid_null_checks_in_equality_operators](https://dart.dev/tools/linter-rules/avoid_null_checks_in_equality_operators)
     - [omit_obvious_local_variable_types](https://dart.dev/tools/linter-rules/omit_obvious_local_variable_types)
     - [specify_nonobvious_local_variable_types](https://dart.dev/tools/linter-rules/specify_nonobvious_local_variable_types)
     - [use_truncating_division](https://dart.dev/tools/linter-rules/use_truncating_division)
   - Removed
     - [unsafe_html](https://dart.dev/tools/linter-rules/unsafe_html)

## 1.15.0

 - **FIX**: No warnings in test directory ([#70](https://github.com/altive/altive_lints/issues/70)). ([02d2fa8a](https://github.com/altive/altive_lints/commit/02d2fa8abb7249232f7eca6b3f99df20239b5fc8))
 - **FEAT**: update all_lint_rules ([#69](https://github.com/altive/altive_lints/issues/69)). ([bce2f105](https://github.com/altive/altive_lints/commit/bce2f105048733af9c77c81481f719a0fe08b146))

## 1.14.1

 - **FIX**: Exclude Colors.transparent from the target of avoid_hardcoded_color ([#63](https://github.com/altive/altive_lints/issues/63)). ([f1a1f5f5](https://github.com/altive/altive_lints/commit/f1a1f5f5cf2a01bac1c032730ff1c44be1857d12))

## 1.14.0

 - **FEAT**: Update all lint rules ([#61](https://github.com/altive/altive_lints/issues/61)). ([cd146c86](https://github.com/altive/altive_lints/commit/cd146c864b6b1ecf243e30a56a5cda7bdb265397))
   - add new rules to `all_lint_rules.yaml` that are available from Dart 3.5.
     - [document_ignores](https://dart.dev/tools/linter-rules/document_ignores)
     - [invalid_runtime_check_with_js_interop_types](https://dart.dev/tools/linter-rules/invalid_runtime_check_with_js_interop_types)
     - The altive_lints enable these rules.

## 1.13.0

 - **FIX**: Add stack to avoid_single_child ([#57](https://github.com/altive/altive_lints/issues/57)). ([c2e3ccb9](https://github.com/altive/altive_lints/commit/c2e3ccb9c62d2ddaa53196ca55adac00a6f45cd8))
 - **FEAT**: Improve prefer_sliver_prefix to prefer_to_include_sliver_in_name ([#58](https://github.com/altive/altive_lints/issues/58)). ([9e9ceb53](https://github.com/altive/altive_lints/commit/9e9ceb5345742271a79b061411dc9f544f619d4d))
 - **DOCS**: Add custom-lint rule description to README ([#56](https://github.com/altive/altive_lints/issues/56)). ([b8eeef22](https://github.com/altive/altive_lints/commit/b8eeef2226e9d3904ada7232799a4808ace4c675))

## 1.12.1

 - **FIX**: Exclude collection-for from the warning of avoid_single_child ([#52](https://github.com/altive/altive_lints/issues/52)). ([6d662328](https://github.com/altive/altive_lints/commit/6d6623287605be70c7a3df9a157ff2bc9cabb1a1))
 - **FIX**: Exclude AvoidHardcodedJapanese from warnings for file names ending in _test.dart ([#54](https://github.com/altive/altive_lints/issues/54)). ([3f3ca05](https://github.com/altive/altive_lints/commit/3f3ca05753c98676383c1507cb8a4438b757539e))

## 1.12.0

 - **FEAT**: Enable public_member_api_docs rule ([#49](https://github.com/altive/altive_lints/issues/49)). ([b46fd8f5](https://github.com/altive/altive_lints/commit/b46fd8f5aa30e499e9c55c044c23be4b5578dacd))

## 1.11.2

 - Update minimum analyzer version to 6.5.0 ([#39](https://github.com/altive/altive_lints/issues/39)). ([c9e9c33](https://github.com/altive/altive_lints/commit/c9e9c3344fc7b558868fa91847b7ae1e5b0aaa17))

## 1.11.1

 - **FIX**: Fixed the potential cast error in `avoid_single_child` ([#41](https://github.com/altive/altive_lints/issues/41)). ([5c0c8b5d](https://github.com/altive/altive_lints/commit/5c0c8b5d732146ed40d2c857e583918c7e2c9671))

## 1.11.0

### Add Custom Lint

If you want to adopt it, specify custom_lints in analysis_options.yaml.
Detailed notation is here: [altive_lints/example/analysis_options.yaml](https://github.com/altive/altive_lints/blob/main/packages/altive_lints/example/analysis_options.yaml)

 - **FEAT**: Add `prefer_sliver_prefix` rule ([#32](https://github.com/altive/altive_lints/issues/32)). ([6c941e72](https://github.com/altive/altive_lints/commit/6c941e725e1e67a55d25365dfc47a27eace01f0c))
 - **FEAT**: Add `prefer_clock_now` rule ([#35](https://github.com/altive/altive_lints/issues/35)). ([e5b056ad](https://github.com/altive/altive_lints/commit/e5b056ad8ff2428e191089d46770e18a38f53d7e))
 - **FEAT**: Add `prefer_dedicated_media_query_methods` rule ([#34](https://github.com/altive/altive_lints/issues/34)). ([945d5e85](https://github.com/altive/altive_lints/commit/945d5e8580fbd7ac77fa3d6a60c6ef8bf522b5f1))
 - **FEAT**: Add `prefer_space_between_elements` rule ([#33](https://github.com/altive/altive_lints/issues/33)). ([1534bffd](https://github.com/altive/altive_lints/commit/1534bffd9361092f19f0caf2410e58f4b043679a))
 - **FEAT**: Add `avoid_consecutive_sliver_to_box_adapter` rule ([#29](https://github.com/altive/altive_lints/issues/29)). ([8a22122a](https://github.com/altive/altive_lints/commit/8a22122a48ff47d260f898fa4f8db23587d04773))
 - **FEAT**: Add `avoid_hardcoded_color` rule ([#31](https://github.com/altive/altive_lints/issues/31)). ([4cfce859](https://github.com/altive/altive_lints/commit/4cfce859348b3ed3cfcc5f1063e706653769f1eb))
 - **FEAT**: Add `avoid_single_child` rule ([#30](https://github.com/altive/altive_lints/issues/30)). ([ac57d755](https://github.com/altive/altive_lints/commit/ac57d755e66fabd10d271b4073ef9dd8b7f29924))
 - **FEAT**: Add `avoid_shrink_wrap_in_list_view` rule ([#28](https://github.com/altive/altive_lints/issues/28)). ([b36d165b](https://github.com/altive/altive_lints/commit/b36d165bb48408f16ad977683f702fb747f56bb7))
 - **FEAT**: Set up custom lint ([#27](https://github.com/altive/altive_lints/issues/27)). ([f6958263](https://github.com/altive/altive_lints/commit/f69582637dd73b71fbd8bef14de5d7a290297215))

## 1.10.0

 - **FEAT**: update all_lint_rules ([#17](https://github.com/altive/altive_lints/issues/17)). ([5cabb1d8](https://github.com/altive/altive_lints/commit/5cabb1d87b593b3ea9f0e088dfb599b9351abdb5))
   - add new rules to `all_lint_rules.yaml`
     - [missing_code_block_language_in_doc_comment](https://dart.dev/tools/linter-rules/missing_code_block_language_in_doc_comment)
     - [unintended_html_in_doc_comment](https://dart.dev/tools/linter-rules/unintended_html_in_doc_comment)
     - [unnecessary_library_name](https://dart.dev/tools/linter-rules/unnecessary_library_name)
   - remove from `all_lint_rules.yaml`
     - [always_require_non_null_named_parameters](https://dart.dev/tools/linter-rules/always_require_non_null_named_parameters)
     - [avoid_returning_null](https://dart.dev/tools/linter-rules/avoid_returning_null)
     - [avoid_returning_null_for_future](https://dart.dev/tools/linter-rules/avoid_returning_null_for_future)
     - [list_remove_unrelated_type](https://dart.dev/tools/linter-rules/list_remove_unrelated_type)
     - [iterable_contains_unrelated_type](https://dart.dev/tools/linter-rules/iterable_contains_unrelated_type)
     - [avoid_unstable_final_fields](https://dart.dev/tools/linter-rules/avoid_unstable_final_fields)

## 1.9.0

 - **FEAT**: update all_lint_rules ([#10](https://github.com/altive/altive_lints/issues/10)). ([31694673](https://github.com/altive/altive_lints/commit/316946734f98d03c764a3e3b704fed59f9bdd444))
   - add new rules to `all_lint_rules.yaml`
     - [annotate_redeclares](https://dart.dev/tools/linter-rules/annotate_redeclares)
     - [avoid_unstable_final_fields](https://dart.dev/tools/linter-rules/avoid_unstable_final_fields)

## 1.8.1
 - fix changelog.
 - fix example pubspec.lock.

## 1.8.0

 - **FEAT**: update all_lint_rules.yaml. ([cd008cb7](https://github.com/altive/altive_lints/commit/cd008cb7c0f0b6b0206d29407596642e45c889d7))
   - add new rules to `all_lint_rules.yaml`
     - [avoid_returning_null](https://dart.dev/tools/linter-rules/avoid_returning_null)
     - [avoid_returning_null_for_future](https://dart.dev/tools/linter-rules/avoid_returning_null_for_future)
     - [always_require_non_null_named_parameters](https://dart.dev/tools/linter-rules/always_require_non_null_named_parameters)
     - [avoid_returning_null_for_void](https://dart.dev/tools/linter-rules/avoid_returning_null_for_void)
     - [no_wildcard_variable_uses](https://dart.dev/tools/linter-rules/no_wildcard_variable_uses)

## 1.7.0

 - **FEAT**: update all_lint_rules.yaml with Flutter 3.10 / Dart 3.0 ([#2](https://github.com/altive/altive_lints/issues/2)). ([1f4c5abf](https://github.com/altive/altive_lints/commit/1f4c5abfcde549a4ed14a505129f9e7e84b17893))
   - add new rules to `all_lint_rules.yaml`
     - `deprecated_member_use_from_same_package`
     - `implicit_reopen`
     - `invalid_case_patterns`
     - `matching_super_parameters`
     - `no_literal_bool_comparisons`
     - `type_literal_in_constant_pattern`
     - `unnecessary_breaks`
   - remove from `all_lint_rules.yaml`
     - `enable_null_safety`

## 1.6.1

 - **DOCS**: fix changelog indents. ([58280f76](https://github.com/altive/altive_lints/commit/58280f76634cfa3ec817fc3499751b99f809245c))

## 1.6.0

 - **FEAT**: update `all_lint_rules.yaml` with Flutter 3.7 / Dart 2.19. ([f464f8d3](https://github.com/altive/altive_lints/commit/f464f8d3765733a627533fb770128c1abe1b2781))
   - remove from `all_lint_rules.yaml` as it has been deprecated
     - `always_require_non_null_named_parameters`
     - `avoid_returning_null`
     - `avoid_returning_null_for_future`
     - `prefer_equal_for_default_values`
   - add new rules
     - `collection_methods_unrelated_type`
     - `dangling_library_doc_comments`
     - `enable_null_safety`
     - `implicit_call_tearoffs`
     - `library_annotations`
     - `unnecessary_library_directive`

## 1.5.0

 - **FEAT**: remove analyzer exclude specification. ([c26891c8](https://github.com/altive/altive_lints/commit/c26891c839a274d7cd1b10449008f53d73d5df86))

## 1.4.0

 - **FEAT**: add rules. ([c1582022](https://github.com/altive/altive_lints/commit/c158202243e7079470f7556359a5dcf923557ea5))
   - `combinators_ordering`
   - `discarded_futures`
   - `unnecessary_null_aware_operator_on_extension_on_nullable`
   - `unnecessary_to_list_in_spreads`
   - `unreachable_from_main`
   - `use_string_in_part_of_directives`
 - **FEAT**: remove `invariant_booleans` as it has been deprecated. ([c1582022](https://github.com/altive/altive_lints/commit/c158202243e7079470f7556359a5dcf923557ea5))

## 1.3.0

 - **FEAT**: re-enable `use_build_context_synchronously`. ([1ec61e89](https://github.com/altive/altive_lints/commit/1ec61e89389d9b53ce8ae703eb559039854cebd0))

## 1.2.0

 - **FEAT**: disable `use_build_context_synchronously`. ([c347f646](https://github.com/altive/altive_lints/commit/c347f646be1b736c8cb9733f9c1a02be1d19b901))
 - **FEAT**: enable `require_trailing_commas`. ([a46b8ec6](https://github.com/altive/altive_lints/commit/a46b8ec678d96b2f35f76984704c5f5551b982f3))

## 1.1.0

 - Bump minimum Dart version from 2.16.2 to 2.17.0

## 1.0.0

Initial release