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
        ColoredBox(color: _colorScheme.primary),
        const ColoredBox(color: Colors.transparent),
      ],
    );
  }
}
ColorScheme get _colorScheme => const ColorScheme(
      primary:Color.fromRGBO(0, 255, 0, 1),
      secondary: Color(0xFFF45479),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFFF3131),
      surface: Color(0xFFFEFEFE),
      surfaceDim: Color(0x1F787880),
      surfaceTint: Color(0xFFF5F5F5),
      surfaceContainerLowest: Color(0xFFF7F7F7),
      surfaceContainerLow: Color(0xFFFAFBFC),
      surfaceContainerHighest: Color(0xFFFFFFFF),
      onSurface: Color(0xFF181A1F),
      onSurfaceVariant: Color(0xFF989898),
      outline: Color(0xFFDCDCDC),
      scrim: Colors.black54,
      onPrimary: Color.fromRGBO(100, 100, 100, 11),
      onError: Color(0xFFFF3131),
      brightness: Brightness.dark,
    );