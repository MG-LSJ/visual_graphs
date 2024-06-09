import 'package:visual_graphs/game_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GameScreen(),
      title: "Visual Graphs",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
