import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/graph_editor.dart';
import 'package:visual_graphs/widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Expanded(
            child: GraphEditorWidget(),
          ),
          Sidebar(),
        ],
      ),
    );
  }
}
