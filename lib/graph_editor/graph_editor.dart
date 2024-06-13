import 'package:visual_graphs/graph_editor/editor_controls.dart';
import 'package:visual_graphs/graph_editor/graph_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';

class GraphEditorWidget extends StatefulWidget {
  const GraphEditorWidget({super.key});

  @override
  State<GraphEditorWidget> createState() => _GraphEditorWidgetState();
}

class _GraphEditorWidgetState extends State<GraphEditorWidget> {
  final GlobalKey _editorControlsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Globals.game = GraphGame();
  }

  @override
  void dispose() {
    Globals.game.resetGraphColors();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Globals.game.editorWidgetContext = context;

    return Stack(
      children: [
        GameWidget(
          game: Globals.game,
        ),
        ListenableBuilder(
          listenable: Globals.game.gameModeNotifier,
          builder: (context, child) {
            _editorControlsKey.currentState?.setState(() {});
            return child!;
          },
          child: EditorControls(key: _editorControlsKey),
        ),
      ],
    );
  }
}
