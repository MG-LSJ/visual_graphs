import 'package:visual_graphs/game_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GameScreen(),
      title: "Algorithm Visualizer",
      theme: ThemeData.light(),
    );
  }
}
