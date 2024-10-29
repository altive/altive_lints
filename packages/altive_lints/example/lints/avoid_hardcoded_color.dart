import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // expect_lint: avoid_hardcoded_color
        const ColoredBox(color: Color(0xFF00FF00)),
        // expect_lint: avoid_hardcoded_color
        const ColoredBox(color: Color.fromRGBO(0, 255, 0, 1)),
        // expect_lint: avoid_hardcoded_color
        const ColoredBox(color: Colors.green),
        ColoredBox(color: Theme.of(context).colorScheme.primary),

        const ColoredBox(color: Colors.transparent),
      ],
    );
  }
}
