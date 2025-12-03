// This file is intended to verify that Analysis rules are enabled.
// Please remove the ignore comment below
// if a warning appears, the check is working correctly.
//
// ignore_for_file: altive_lints/avoid_consecutive_sliver_to_box_adapter, altive_lints/avoid_hardcoded_color, altive_lints/avoid_hardcoded_japanese, altive_lints/avoid_shrink_wrap_in_list_view, altive_lints/avoid_single_child, altive_lints/prefer_clock_now, altive_lints/prefer_dedicated_media_query_methods, altive_lints/prefer_space_between_elements, altive_lints/prefer_to_include_sliver_in_name
import 'package:flutter/material.dart';

class AvoidConsecutiveSliverToBoxAdaptersExample extends StatelessWidget {
  const AvoidConsecutiveSliverToBoxAdaptersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverToBoxAdapter(
            child: Text('Hello'),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverToBoxAdapter(
            child: Text('World'),
          ),
        ),
      ],
    );
  }
}

class AvoidHardcodedColorExample extends StatelessWidget {
  const AvoidHardcodedColorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ColoredBox(color: Color(0xFF00FF00)),
        const ColoredBox(color: Colors.green),
      ],
    );
  }
}

const hiragana = 'あいうえお';

class AvoidShrinkWrapInListViewExample extends StatelessWidget {
  const AvoidShrinkWrapInListViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Text('Hello World!'),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Text('Hello'),
                Text('World'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AvoidSingleChildExample extends StatelessWidget {
  const AvoidSingleChildExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Hello'),
      ],
    );
  }
}

final dateTimeNow = DateTime.now();

class PreferDedicatedMediaQueryMethodsExample extends StatelessWidget {
  const PreferDedicatedMediaQueryMethodsExample({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = MediaQuery.of(context).size;
    return const SizedBox.shrink();
  }
}

class PreferSpaceBetweenElementsExample extends StatelessWidget {
  const PreferSpaceBetweenElementsExample({
    super.key,
    required this.id,
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PreferToIncludeFooInNameExample extends StatelessWidget {
  const PreferToIncludeFooInNameExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const Placeholder();
      },
    );
  }
}
