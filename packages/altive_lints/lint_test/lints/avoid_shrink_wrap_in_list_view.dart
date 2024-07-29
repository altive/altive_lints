// ignore_for_file: avoid_single_child
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Expanded(
            // expect_lint: avoid_shrink_wrap_in_list_view
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
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
