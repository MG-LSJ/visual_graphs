import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/queue.dart';

class Pair {
  final Vertex v;
  final Edge? e;

  Pair(this.v, this.e);
}

class BreadthFirstSearch {
  final Graph graph;
  final Vertex start;

  final QueueDS<Pair> queue = QueueDS();

  final Set<Vertex> visited = {};
  final Set<Vertex> seen = {};

  BreadthFirstSearch({required this.graph, required this.start});

  void search() async {
    print("Starting BFS from ${start.label}");
    await see(Pair(start, null));

    while (queue.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));

      final pair = queue.dequeue();
      await visit(pair);

      var neighbours = pair.v.neighbours;

      for (final neighbour in neighbours.keys) {
        if (!seen.contains(neighbour)) {
          await see(Pair(neighbour, neighbours[neighbour]!.first));
        }
      }
    }
  }

  Future see(Pair pair) async {
    print("Seeing ${pair.v.label}");

    queue.enqueue(pair);

    seen.add(pair.v);

    if (pair.e != null && pair.e?.component != null) {
      pair.e?.component
        ?..color = Colors.orange
        ..hoverColor = Colors.orangeAccent
        ..hoverOut();

      await Future.delayed(const Duration(milliseconds: 100));
    }

    pair.v.component
      ..color = Colors.orange
      ..hoverColor = Colors.orangeAccent
      ..onHoverExit();
  }

  Future visit(Pair pair) async {
    print("Visiting ${pair.v.label} via ${pair.e}");

    visited.add(pair.v);

    if (pair.e != null && pair.e?.component != null) {
      pair.e?.component
        ?..color = Colors.green
        ..hoverColor = Colors.greenAccent
        ..hoverOut();

      await Future.delayed(const Duration(milliseconds: 100));
    }

    pair.v.component
      ..color = Colors.green
      ..hoverColor = Colors.greenAccent
      ..onHoverExit();
  }
}
