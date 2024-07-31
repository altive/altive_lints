import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // expect_lint: avoid_single_child
        const Column(
          children: [
            Text('Hello'),
          ],
        ),
        // expect_lint: avoid_single_child
        const Row(
          children: [
            Text('World'),
          ],
        ),
        // expect_lint: avoid_single_child
        const Flex(
          direction: Axis.horizontal,
          children: [
            Text('Hello'),
          ],
        ),
        // expect_lint: avoid_single_child
        const Wrap(
          children: [
            Text('World'),
          ],
        ),
        // expect_lint: avoid_single_child
        ListView(
          children: const [
            Text('Hello'),
          ],
        ),
        // expect_lint: avoid_single_child
        SliverList.list(
          children: const [
            Text('World'),
          ],
        ),
        ListView(
          children: List.generate(
            10,
            (index) => Text('Hello $index'),
          ),
        ),
      ],
    );
  }
}
