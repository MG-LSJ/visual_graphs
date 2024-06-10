import 'package:visual_graphs/graph_editor/graph_editor.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GraphEditorWidget(),
      title: "Visual Graphs",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
