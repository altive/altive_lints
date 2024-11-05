import 'dart:math';

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var isValued = Random().nextBool();
    final random = Random();
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
        const Stack(
          children: [
            Text('Hello'),
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
            Text('Hello'),
          ],
        ),
        // expect_lint: avoid_single_child
        Column(
          children: [
            if (random.nextBool()) const Text('Hello World'),
          ],
        ),
        // expect_lint: avoid_single_child
        Column(
          children: [
            if (random.nextBool())
              const Text('Hello World')
            else ...[
              const Text('Hello'),
            ],
          ],
        ),
        Column(
          children: random.nextBool()
              ? [
                  const Text('Hello World'),
                ]
              : [
                  const Text('Hello'),
                  const Text('World'),
                ],
        ),
        if (random.nextBool())
          const Text('Hello World')
        else
          const Column(
            children: [
              Text('Hello'),
              Text('World'),
            ],
          ),
        ListView(
          children: List.generate(
            10,
            (index) => Text('Hello $index'),
          ),
        ),
        Row(
          children: [
            for (var i = 0; i < 10; i++) Text('Hello $i'),
          ],
        ),
        SliverList.list(
          children: [
            for (final e in ['a', 'b', 'c']) Text('Hello $e'),
          ],
        ),
        Column(
          children: [
            if (random.nextBool()) const Text('Hello 1'),
            if (random.nextBool()) const Text('Hello 2'),
          ],
        ),
        const Column(),
        // Ignore this for the sake of example.
        // ignore: avoid_redundant_argument_values
        const Column(children: []),
        // expect_lint: avoid_single_child
        Column(
          children: [
            if(isValued)...[
              Container(),
            ]else...[
              Container(),
            ],
          ],
        ),
      ],
    );
  }
}
