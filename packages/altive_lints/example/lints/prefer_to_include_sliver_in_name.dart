import 'package:flutter/material.dart';

// expect_lint: prefer_to_include_sliver_in_name
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

// expect_lint: prefer_to_include_sliver_in_name
class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key, this.maxCount = 10});

  const MyWidget2.small({super.key, this.maxCount = 5});

  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: maxCount,
      itemBuilder: (context, index) {
        return const Placeholder();
      },
    );
  }
}

class MySliverWidget extends StatelessWidget {
  const MySliverWidget({super.key});

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

class MyWidget3 extends StatelessWidget {
  const MyWidget3({super.key});

  const MyWidget3.sliver({super.key});

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
