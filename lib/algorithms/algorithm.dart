import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';

abstract class Algorithm {
  bool isRunning = false;

  final Graph graph = Globals.game.graph;

  void start() async {}

  void initialize() {
    Globals.game.gameMode = GameMode.lockedMode;
    clear();
    Globals.game.greyOutGraphComponents();
    isRunning = true;
  }

  void finalize() {
    isRunning = false;
  }

  void clear() {
    isRunning = false;
  }
}
