## 1.1.0

 - **FIX**: `prefer_dedicated_media_query_methods` allows copying the full
   `MediaQueryData` returned by `MediaQuery.of` or `MediaQuery.maybeOf`.
 - **FEAT**: `prefer_widget_class` diagnoses functions, methods, and getters
   that return Flutter widgets, except framework `build` methods.

## 1.0.0

 - **FEAT**: extract the Analyzer Plugin implementation from `altive_lints` 3.x.
 - Preserve all custom lint rules, fixes, and assists from `altive_lints` 3.1.0.
 - Use the `altive_lints_plugin` diagnostic prefix.
 - **FIX**: preserve method indentation when adding a macro document comment.
