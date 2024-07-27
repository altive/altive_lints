import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          // expect_lint: avoid_sliver_to_box_adapter
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text('Hello'),
                Text('World'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
