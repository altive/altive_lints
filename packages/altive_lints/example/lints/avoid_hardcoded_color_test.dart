// Check the `avoid_hardcoded_color` rule.
//
// This file ends with the name `_test.dart`,
// so it should be exempt from the warning.

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ColoredBox(color: Color(0xFF00FF00)),
        const ColoredBox(color: Color.fromRGBO(0, 255, 0, 1)),
        const ColoredBox(color: Colors.green),
        ColoredBox(color: Theme.of(context).colorScheme.primary),
        ColoredBox(color: _colorScheme.primary),
        const ColoredBox(color: Colors.transparent),
      ],
    );
  }
}

ColorScheme get _colorScheme => const ColorScheme.dark(
      primary: Color.fromRGBO(0, 255, 0, 1),
    );
