import 'package:flutter/material.dart';

// expect_lint: prefer_sliver_prefix
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

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
