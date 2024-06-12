import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';

bool pickStartingVertex(BuildContext context) {
  if (Globals.game.graph.vertices.isEmpty) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Add vertices to the graph"),
      ),
    );
    return false;
  }

  if (Globals.game.gameMode != GameMode.pickVertex) {
    Globals.game.gameMode = GameMode.pickVertex;
    return false;
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pick a starting vertex"),
      ),
    );
    return false;
  }
}
