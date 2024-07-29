import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // expect_lint: prefer_dedicated_media_query_methods
    final size = MediaQuery.of(context).size;
    // expect_lint: prefer_dedicated_media_query_methods
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Column(
      children: [
        Text('Size: $size'),
        Text('ViewInsets: $viewInsets'),
      ],
    );
  }
}
