## 1.8.1

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