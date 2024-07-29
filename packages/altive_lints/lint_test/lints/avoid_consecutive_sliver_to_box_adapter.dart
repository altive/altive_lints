import 'package:flutter/material.dart';

class ConsecutiveSliverToBoxAdapters extends StatelessWidget {
  const ConsecutiveSliverToBoxAdapters({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      // expect_lint: avoid_consecutive_sliver_to_box_adapter
      slivers: [
        SliverToBoxAdapter(
          child: Text('Hello'),
        ),
        SliverToBoxAdapter(
          child: Text('World'),
        ),
      ],
    );
  }
}

class ConsecutiveSliverToBoxAdaptersWithSliverPadding extends StatelessWidget {
  const ConsecutiveSliverToBoxAdaptersWithSliverPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      // expect_lint: avoid_consecutive_sliver_to_box_adapter
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

class NonConsecutiveSliverToBoxAdapters extends StatelessWidget {
  const NonConsecutiveSliverToBoxAdapters({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Text('Hello'),
        ),
        SliverList.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const SliverToBoxAdapter(
              child: Text('item'),
            );
          },
        ),
        const SliverToBoxAdapter(
          child: Text('World'),
        ),
      ],
    );
  }
}
