import 'package:visual_graphs/graph_editor/graph_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/widgets/game_info_box.dart';

final squareIconButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

class GraphEditorWidget extends StatefulWidget {
  const GraphEditorWidget({super.key});

  @override
  State<GraphEditorWidget> createState() => _GraphEditorWidgetState();
}

class _GraphEditorWidgetState extends State<GraphEditorWidget> {
  @override
  void initState() {
    super.initState();
    Globals.game = GraphGame(
      editorWidgetState: this,
    );
  }

  @override
  void dispose() {
    Globals.game.resetGraphColors();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Globals.game.editorWidgetContext = context;
    bool smallScreen = MediaQuery.of(context).size.width < 600;
    return Stack(
      children: [
        GameWidget(
          game: Globals.game,
        ),
        if (Globals.game.gameMode == GameMode.pickVertex)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 40),
                const Spacer(),
                const Text(
                  "Pick a vertex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 40,
                  child: IconButton.filledTonal(
                    tooltip: "Cancel",
                    onPressed: () => Globals.game.restorePreviousGameMode(),
                    icon: const Icon(Icons.cancel),
                    style: squareIconButtonStyle,
                  ),
                )
              ],
            ),
          ),
        if (Globals.game.gameMode != GameMode.pickVertex)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Globals.game.gameMode == GameMode.lockedMode)
                  IconButton.filled(
                    onPressed: () => setState(() {
                      Globals.game.gameMode = GameMode.defaultMode;
                    }),
                    icon: const Icon(Icons.edit),
                    style: squareIconButtonStyle,
                  ),
                if (Globals.game.gameMode != GameMode.lockedMode)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => setState(() {
                              Globals.game.gameMode = GameMode.lockedMode;
                            }),
                            icon: const Icon(Icons.done),
                            style: squareIconButtonStyle,
                          ),
                          const Spacer(),
                          IconButton.filled(
                            icon: const Icon(Icons.undo),
                            onPressed: Globals.game.undoStack.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      Globals.game.undo();
                                    });
                                  },
                            tooltip: "Undo",
                            disabledColor: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<GameMode>(
                        segments: [
                          ButtonSegment(
                            value: GameMode.defaultMode,
                            label: !smallScreen ? const Text("Default") : null,
                            icon: const Icon(Icons.mouse),
                            tooltip: smallScreen ? "Default Mode" : null,
                          ),
                          ButtonSegment(
                            value: GameMode.addVertex,
                            label:
                                !smallScreen ? const Text("Add Vertex") : null,
                            icon: const Icon(Icons.add),
                            tooltip: smallScreen ? "Add Vertex" : null,
                          ),
                          ButtonSegment(
                            value: GameMode.addEdge,
                            label: !smallScreen ? const Text("Add Edge") : null,
                            icon: const Icon(Icons.linear_scale),
                            tooltip: smallScreen ? "Add Edge" : null,
                          ),
                          ButtonSegment(
                            value: GameMode.deleteComponent,
                            label: !smallScreen ? const Text("Delete") : null,
                            icon: const Icon(Icons.delete),
                            tooltip: smallScreen ? "Delete" : null,
                          ),
                        ],
                        style: SegmentedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          selectedForegroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          selectedBackgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        showSelectedIcon: false,
                        selected: {Globals.game.gameMode},
                        onSelectionChanged: (p0) => setState(() {
                          Globals.game.gameMode = p0.first;
                        }),
                      ),
                      const SizedBox(height: 10),
                      if (Globals.game.gameMode == GameMode.addEdge)
                        Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox.adaptive(
                                  visualDensity: VisualDensity.compact,
                                  value: Globals.game.addEdgeModeIsDirected,
                                  onChanged: (value) {
                                    setState(() {
                                      Globals.game.addEdgeModeIsDirected =
                                          value!;
                                    });
                                  },
                                ),
                                const Text("Directed"),
                                const SizedBox(width: 20),
                                Checkbox.adaptive(
                                  value: Globals.game.addEdgeModeIsWeighted,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) {
                                    setState(() {
                                      Globals.game.addEdgeModeIsWeighted =
                                          value!;
                                    });
                                  },
                                ),
                                const Text("Weighted"),
                              ],
                            ),
                          ),
                        ),
                      if (Globals.game.gameMode == GameMode.addEdge)
                        const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {
                          Globals.game.clearGraph();
                        }),
                        label: const Text("Clear Graph"),
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Globals.game.centerCamera(),
                      icon: const Icon(
                        Icons.center_focus_strong,
                        color: Colors.white,
                      ),
                      tooltip: "Center Camera",
                    ),
                    const Spacer(),
                    FloatingActionButton.small(
                      tooltip: "Help",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const GameInfoBox(),
                        );
                      },
                      child: const Icon(Icons.help),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
