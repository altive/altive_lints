# Altive Lints

Provides `all_lint_rules.yaml` that activates all rules and `altive_lints.yaml` with Altive recommended rule selection.

There are also Altive-made rules by custom_lint.

## Table of content

- [Table of content](#table-of-content)
- [Getting started](#getting-started)
  - [altive\_lints](#altive_lints)
  - [Enable custom\_lint](#enable-custom_lint)
  - [Disabling lint rules](#disabling-lint-rules)
- [All custom-lint rules in altive\_lints](#all-custom-lint-rules-in-altive_lints)
  - [avoid\_consecutive\_sliver\_to\_box\_adapter](#avoid_consecutive_sliver_to_box_adapter)
  - [avoid\_hardcoded\_color](#avoid_hardcoded_color)
  - [avoid\_hardcoded\_japanese](#avoid_hardcoded_japanese)
  - [avoid\_shrink\_wrap\_in\_list\_view](#avoid_shrink_wrap_in_list_view)
  - [avoid\_single\_child](#avoid_single_child)
  - [prefer\_clock\_now](#prefer_clock_now)
  - [prefer\_dedicated\_media\_query\_methods](#prefer_dedicated_media_query_methods)
  - [prefer\_to\_include\_sliver\_in\_name](#prefer_to_include_sliver_in_name)
  - [prefer\_space\_between\_elements](#prefer_space_between_elements)
- [Lint rules adopted by altive\_lints and why](#lint-rules-adopted-by-altive_lints-and-why)
  - [public\_member\_api\_docs](#public_member_api_docs)
- [Migration guide](#migration-guide)
  - [v1.12.0](#v1120)

## Getting started

### altive_lints

1. Add altive_lints to your `pubspec.yaml`:
  ```yaml
  dev_dependencies:
    altive_lints:
  ```
2. Include altive_lints in analysis_options.yaml.<br/>
If not, create a new one or copy [analysis_options.yaml](https://github.com/altive/altive_lints/blob/main/packages/altive_lints/example/analysis_options.yaml) and use it.

  ```yaml
  include: package:altive_lints/altive_lints.yaml
  ```

### Enable custom_lint

altive_lints comes bundled with its own rules using custom_lints.

- Add both altive_lints and custom_lint to your `pubspec.yaml`:
  ```yaml
  dev_dependencies:
    altive_lints:
    custom_lint: # <- add this
  ```
- Enable `custom_lint`'s plugin in your `analysis_options.yaml`:

  ```yaml
  include: package:altive_lints/altive_lints.yaml
  analyzer:
    plugins:
      - custom_lint
  ```

### Disabling lint rules

By default when installing altive_lints, most of the lints will be enabled.
To change this, you have a few options.

```yaml
include: package:altive_lints/altive_lints.yaml
analyzer:
  plugins:
    - custom_lint

linter:
  rules:
    # Explicitly disable one lint rule.
    - public_member_api_docs: false

custom_lint:
  rules:
    # Explicitly disable one custom-lint rule.
    - avoid_hardcoded_color: false
```

## All custom-lint rules in altive_lints

### avoid_consecutive_sliver_to_box_adapter

SliverToBoxAdapter must not be placed consecutively in slivers of CustomScrollView.

**Bad**:

```dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(child: Text('Item 1')), // Consecutive usage
    SliverToBoxAdapter(child: Text('Item 2')), // LINT
  ],
);
```

**Good**:

```dart
CustomScrollView(
  slivers: [
    SliverList.list(
      children: [
        Text('Item 1')
        Text('Item 2')
      ],
    ),
  ],
);
```

### avoid_hardcoded_color

Do not use hard-coded Color.

**Bad**:

```dart
ColoredBox(
  color: Color(0xFF00FF00), // LINT
);
```

**Good**:

```dart
ColoredBox(
  color: Theme.of(context).colorScheme.primary,
);
```

### avoid_hardcoded_japanese

Hard-coded Japanese text strings must not be used.
Use AppLocalizations, etc. to support internationalization.

Not applicable on test files.

**Bad**:

```dart
final message = 'こんにちは'; // LINT
print('エラーが発生しました'); // LINT
```

**Good**:

```dart
final message = AppLocalizations.of(context).hello;
print(AppLocalizations.of(context).errorOccurred);
```

### avoid_shrink_wrap_in_list_view

The shrinkWrap property must not be used in a ListView.

Use CustomScrollView and SliverList instead.

However, it is OK to use shrinkWrap if it is used to reduce the size of a dialog, such as when there is extra height in the dialog, so use `ignore` explicitly in such cases.


**Bad**:

```dart
ListView(
  shrinkWrap: true, // LINT
  children: [
    Text('Hello'),
    Text('World'),
  ],
);
```

**Good**:

```dart
CustomScrollView(
  slivers: [
    SliverList.list(
      children: [
        Text('Hello'),
        Text('World'),
      ],
    ),
  ],
);
```

### avoid_single_child

The `children` property is intended to have multiple elements and should not be used with only one child element.

**Bad**:

```dart
Column(
  children: [YourWidget()], // LINT
);
```

**Good**:

```dart
Center(child: YourWidget());
// or
Column(
  children: [YourWidget1(), YourWidget2()],
);
```

### prefer_clock_now

Prefer using clock.now() instead of DateTime.now().

By using the [clock](https://pub.dev/packages/clock) package and clock.now(), you can use the withClock method to replace the date and time at test time.

**Bad**:

```dart
var now = DateTime.now(); // LINT
```

**Good**:

```dart
var now = clock.now(); // Using 'clock' package
```

### prefer_dedicated_media_query_methods

Prefer to use dedicated `MediaQuery` methods instead of `MediaQuery.of` or `MediaQuery.maybeOf`.

This is to reduce unnecessary widget rebuilding and improve performance by using dedicated methods such as `MediaQuery.sizeOf` and `MediaQuery.viewInsetsOf`.

**Bad**:

```dart
var size = MediaQuery.of(context).size; // LINT
var padding = MediaQuery.maybeOf(context)?.padding; // LINT
```

**Good**:

```dart
var size = MediaQuery.sizeOf(context);
var padding = MediaQuery.viewInsetsOf(context);
```

### prefer_to_include_sliver_in_name

Prefer to include ‘Sliver’ in the class name or named constructor of a widget that returns a Sliver-type widget.

This makes it easy for the user to know at a glance that it is a Sliver type Widget, and improves readability and consistency.

**Bad**:

```dart
class MyCustomList extends StatelessWidget { // LINT
  @override
  Widget build(BuildContext context) {
    return SliverList(...);
  }
}

```

**Good**:

```dart
class SliverMyCustomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(...);
  }
}
```

### prefer_space_between_elements

Prefer to insert blank lines for spacing rules in class definitions.
between constructors and fields, and between constructors and build methods.

The purpose of proper spacing is to improve code readability and organization and to make it easier to visually distinguish between different sections of a class.


**Bad**:

```dart
class MyWidget extends StatelessWidget {
  MyWidget(this.title);
  final String title; // LINT
  @override // LINT
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

**Good**:

```dart
class MyWidget extends StatelessWidget {
  MyWidget(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
```

## Lint rules adopted by altive_lints and why

Reasons for adopting each lint rule.

All lint rules disabled by altive_lints and their reasons can be found in [altive_lints.yaml](https://github.com/altive/altive_lints/blob/main/packages/altive_lints/lib/altive_lints.yaml).

### [public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs)

Even the best naming is difficult to grasp the big picture unless it is very simple.

An overview of it and documentation of why it exists and how to use it will help your teammates and future self.

> [!NOTE]
> If there are too many applicable sections,
> such as when introducing the rule to an existing project,
> it is recommended to disable the rule once and then gradually address the issue.

**Bad**:

```dart
class DashboardCard extends StatelessWidget {
  DashboardCard({required this.title, required this.content});

  final String title;
  final Widget content;
  ...
}
```

**Good**:

```dart
/// Cards to display an overview of each function on the dashboard.
///
/// [title] and [content] are required and cannot be omitted.
class DashboardCard extends StatelessWidget {

  /// Creates a card-like widget to be placed on the dashboard.
  DashboardCard({required this.title, required this.content});

  /// A title string indicating the content to be displayed on the card.
  final String title;

  /// A widget to be displayed below the title.
  ///
  /// We assume text, images, graphs, etc., but basically anything can be included.
  /// Consider using [Column] if you want to arrange multiple pieces of content vertically.
  final Widget content;
  ...
}

```

## Migration guide

### v1.12.0

The [public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs) prompt to add documents has been activated.
Please add documentation comments to public members.

If there are too many issues, disable them in analysis_options.yaml.