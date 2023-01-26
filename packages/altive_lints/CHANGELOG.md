## 1.6.0

 - **FEAT**: update all_lint_rules with Flutter 3.7/Dart 2.19. ([f464f8d3](https://github.com/altive/altive_lints/commit/f464f8d3765733a627533fb770128c1abe1b2781))
  -  remove from all_lint_rules as it has been deprecated
    - always_require_non_null_named_parameters
    - avoid_returning_null
    - avoid_returning_null_for_future
    - prefer_equal_for_default_values

  -  add new rules
    - collection_methods_unrelated_type
    - dangling_library_doc_comments
    - enable_null_safety
    - implicit_call_tearoffs
    - library_annotations
    - unnecessary_library_directive

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