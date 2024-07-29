import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // expect_lint: prefer_space_between_elements
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyWidget2 extends StatelessWidget {
  const MyWidget2({
    super.key,
    required this.id,
  }); // expect_lint: prefer_space_between_elements
  final String id; // expect_lint: prefer_space_between_elements
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
