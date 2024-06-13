import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/data_structures/pair.dart';
import 'package:visual_graphs/helpers/notifiers/set_notifier.dart';

abstract class Traversal {
  final Graph graph;
  final SetNotifier<Vertex> visited = SetNotifier();
  final SetNotifier<Vertex> seen = SetNotifier();
  final delay = const Duration(seconds: 1);
  bool isRunning = false;

  final ValueNotifier<Vertex?> visitingVertexNotifier = ValueNotifier(null);

  Traversal({required this.graph});

  void start(Vertex startVertex);

  Future end() async {
    isRunning = false;
    if (visitingVertexNotifier.value != null) {
      visitingVertexNotifier.value?.component
        ?..radius = Globals.defaultVertexRadius
        ..drawBorder = false
        ..setColors(
          Colors.lightGreen,
          Colors.lightGreenAccent,
        );

      visitingVertexNotifier.value = null;
    }
  }

  Future see(Pair<Vertex, Edge?> pair) async {
    if (pair.second != null && pair.second?.component != null) {
      pair.second?.component.setColors(Colors.orange, Colors.orange);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    pair.first.component.setColors(Colors.orange, Colors.orangeAccent);
    seen.add(pair.first);
  }

  Future visit(Pair pair) async {
    if (pair.second != null && pair.second?.component != null) {
      pair.second?.component.setColors(Colors.lightGreen, Colors.lightGreen);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (visitingVertexNotifier.value != null) {
      visitingVertexNotifier.value?.component
        ?..radius = Globals.defaultVertexRadius
        ..drawBorder = false
        ..setColors(
          Colors.lightGreen,
          Colors.lightGreenAccent,
        );
    }
    visitingVertexNotifier.value = pair.first;

    pair.first.component
      ..radius = Globals.defaultVertexRadius + 5
      ..drawBorder = true
      ..setColors(Colors.green, Colors.greenAccent);

    visited.add(pair.first);
  }

  void clear() {
    visited.clear();
    seen.clear();
    isRunning = false;
    visitingVertexNotifier.value = null;
  }

  List<Vertex> get visitedVertices {
    return visited.set.toList();
  }

  List<Vertex> get seenVertices {
    return seen.set.toList();
  }
}
