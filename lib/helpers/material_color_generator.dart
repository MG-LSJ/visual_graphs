import 'package:flutter/material.dart';

class MaterialColorGenerator {
  final List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
  ];

  int index = 0;

  MaterialColorGenerator() {
    colors.shuffle();
  }

  Color next() {
    if (index == colors.length) {
      index = 0;
    }
    return colors[index++];
  }
}
