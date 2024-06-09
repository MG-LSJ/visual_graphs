import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:visual_graphs/components/graph_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/widgets/game_info_box.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GraphGame game;

  @override
  void initState() {
    super.initState();
    game = GraphGame();
    game.parentWidgetState = this;
  }

  @override
  Widget build(BuildContext context) {
    game.context = context;
    bool smallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      label: !smallScreen ? const Text("Add Vertex") : null,
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
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    selectedForegroundColor:
                        Theme.of(context).colorScheme.onPrimary,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                  ),
                  showSelectedIcon: false,
                  selected: {game.gameMode},
                  onSelectionChanged: (p0) => setState(() {
                    game.gameMode = p0.first;
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => setState(() {
                    game.clearGraph();
                  }),
                  label: const Text("Clear Graph"),
                  icon: const Icon(Icons.clear),
                ),
                Expanded(child: Container()),
                IconButton(
                  onPressed: () => game.centerCamera(),
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
    );
  }
}
