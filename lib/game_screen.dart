import 'package:visual_graphs/components/graph_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
                  segments: const [
                    ButtonSegment(
                      value: GameMode.defaultMode,
                      label: Text("Default"),
                      icon: Icon(Icons.mouse),
                    ),
                    ButtonSegment(
                      value: GameMode.addVertex,
                      label: Text("Add Vertex"),
                      icon: Icon(Icons.add),
                    ),
                    ButtonSegment(
                      value: GameMode.addEdge,
                      label: Text("Add Edge"),
                      icon: Icon(Icons.linear_scale),
                    ),
                    ButtonSegment(
                      value: GameMode.deleteComponent,
                      label: Text("Delete Component"),
                      icon: Icon(Icons.delete),
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
                  onPressed: () => game.centerCamera(),
                  icon: const Icon(Icons.center_focus_strong),
                  label: const Text("Center Camera"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => setState(() {
                    game.clearGraph();
                  }),
                  label: const Text("Clear Graph"),
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
