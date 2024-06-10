import 'package:flutter/material.dart';
import 'package:visual_graphs/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      title: "Visual Graphs",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
