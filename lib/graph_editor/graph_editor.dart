// import 'package:visual_graphs/algorithms/bfs.dart';
// import 'package:visual_graphs/algorithms/dfs.dart';
import 'package:visual_graphs/graph_editor/components/graph_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/widgets/game_info_box.dart';

final squareIconButtonStyle = ButtonStyle(
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);

class GraphEditorWidget extends StatefulWidget {
  GraphEditorWidget({super.key}) {
    game = GraphGame();
  }

  @override
  State<GraphEditorWidget> createState() => _GraphEditorWidgetState();

  late final GraphGame game;
}

class _GraphEditorWidgetState extends State<GraphEditorWidget> {
  @override
  void initState() {
    super.initState();
    widget.game.parentWidgetState = this;
  }

  @override
  Widget build(BuildContext context) {
    widget.game.context = context;
    bool smallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: widget.game,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.game.gameMode == GameMode.lockedMode)
                  IconButton.filled(
                    onPressed: () => setState(() {
                      widget.game.gameMode = GameMode.defaultMode;
                    }),
                    icon: const Icon(Icons.edit),
                    style: squareIconButtonStyle,
                  ),
                if (widget.game.gameMode != GameMode.lockedMode)
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
                              widget.game.gameMode = GameMode.lockedMode;
                            }),
                            icon: const Icon(Icons.done),
                            style: squareIconButtonStyle,
                          ),
                          Expanded(child: Container()),
                          IconButton.filled(
                            icon: const Icon(Icons.undo),
                            onPressed: widget.game.undoStack.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      widget.game.undo();
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
                        selected: {widget.game.gameMode},
                        onSelectionChanged: (p0) => setState(() {
                          widget.game.gameMode = p0.first;
                        }),
                      ),
                      const SizedBox(height: 10),
                      if (widget.game.gameMode == GameMode.addEdge)
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
                                  value: widget.game.addEdgeModeIsDirected,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.game.addEdgeModeIsDirected =
                                          value!;
                                    });
                                  },
                                ),
                                const Text("Directed"),
                                const SizedBox(width: 20),
                                Checkbox.adaptive(
                                  value: widget.game.addEdgeModeIsWeighted,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.game.addEdgeModeIsWeighted =
                                          value!;
                                    });
                                  },
                                ),
                                const Text("Weighted"),
                              ],
                            ),
                          ),
                        ),
                      if (widget.game.gameMode == GameMode.addEdge)
                        const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => setState(() {
                          widget.game.clearGraph();
                        }),
                        label: const Text("Clear Graph"),
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                Expanded(child: Container()),
                IconButton(
                  onPressed: () => widget.game.centerCamera(),
                  icon: const Icon(
                    Icons.center_focus_strong,
                    color: Colors.white,
                  ),
                  tooltip: "Center Camera",
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        tooltip: "Help",
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const GameInfoBox(),
          );
        },
        child: const Icon(Icons.help),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var bfs = BreadthFirstSearch(
      //         graph: game.graph, start: game.graph.vertices.first);
      //     bfs.search();
      //   },
      //   child: const Icon(Icons.star),
      // ),
    );
  }
}
