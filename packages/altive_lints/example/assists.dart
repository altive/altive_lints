// This file is for testing the Assists feature of the Analyzer Plugin.

import 'package:flutter/material.dart';

@immutable
class MyClass {
  MyClass({required this.myField});

  MyClass.emptyName() : myField = '';

  final String myField;

  void myMethod() {
    print('Hello, $myField!');
  }
}

void myFunction() {
  print('Hello, World!');
}

mixin MyMixin {
  void myMixinMethod() {
    print('Hello, World!');
  }
}

enum MyEnum {
  one,
  two,
  three,
}

extension type MyExtensionType(int value) implements int {
  bool get isZero => value == 0;
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello, World!'),
    );
  }
}
