import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/queue.dart';

class Pair {
  final Vertex v;
  final Edge? e;

  Pair(this.v, this.e);
}

class BreadthFirstTraversal {
  final Graph graph;

  final QueueDS<Pair> _queue = QueueDS();

  final Set<Vertex> visited = {};
  final Set<Vertex> seen = {};

  bool isRunning = false;
  State state;

  Vertex? visiting;

  BreadthFirstTraversal({required this.graph, required this.state});

  final delay = const Duration(seconds: 1);

  void start(Vertex startVertex) async {
    clear();
    isRunning = true;
    print("starting BFS from ${startVertex.label}");
    await see(Pair(startVertex, null));
    await Future.delayed(delay);

    while (_queue.isNotEmpty) {
      final pair = _queue.dequeue();
      await visit(pair);

      var neighbours = pair.v.neighbours;

      for (final neighbour in neighbours.keys) {
        if (!seen.contains(neighbour)) {
          see(Pair(neighbour, neighbours[neighbour]!.first));
        }
      }
      await Future.delayed(delay);
    }
    await end();
  }

  Future end() async {
    isRunning = false;
    if (visiting != null) {
      visiting?.component
        ?..radius = Globals.defaultVertexRadius
        ..drawBorder = false
        ..setColors(
          Colors.lightGreen,
          Colors.lightGreenAccent,
        );
      state.setState(() {});
    }
  }

  Future see(Pair pair) async {
    print("Seeing ${pair.v.label}");
    // _queue.enqueue(pair);
    // seen.add(pair.v);

    if (pair.e != null && pair.e?.component != null) {
      pair.e?.component.setColors(Colors.orange, Colors.orange);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    pair.v.component.setColors(Colors.orange, Colors.orangeAccent);
    state.setState(() {
      _queue.enqueue(pair);
      seen.add(pair.v);
    });
  }

  Future visit(Pair pair) async {
    print("Visiting ${pair.v.label} via ${pair.e}");
    // visited.add(pair.v);

    if (pair.e != null && pair.e?.component != null) {
      pair.e?.component.setColors(Colors.lightGreen, Colors.lightGreen);
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (visiting != null) {
      visiting?.component
        ?..radius = Globals.defaultVertexRadius
        ..drawBorder = false
        ..setColors(
          Colors.lightGreen,
          Colors.lightGreenAccent,
        );
    }
    visiting = pair.v;

    pair.v.component
      ..radius = Globals.defaultVertexRadius + 5
      ..drawBorder = true
      ..setColors(Colors.green, Colors.greenAccent);

    state.setState(() {
      visited.add(pair.v);
    });
  }

  void clear() {
    visited.clear();
    seen.clear();
    _queue.clear();
    isRunning = false;
    visiting = null;
    state.setState(() {});
  }

  List<Vertex> get queue {
    return List.from(
      _queue.queue.map((pair) => pair.v),
    );
  }
}
