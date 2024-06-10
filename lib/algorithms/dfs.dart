import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/stack.dart';

class DepthFirstSearch {
  final Graph graph;
  final Vertex start;
  final StackDS<Vertex> stack = StackDS();

  final Set<Vertex> visited = {};
  final Set<Vertex> seen = {};

  DepthFirstSearch({required this.graph, required this.start});

  void search() async {
    print("Starting DFS from ${start.label}");
    see(start);

    while (stack.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1));

      final vertex = stack.pop();
      visit(vertex);

      var neighbours = vertex.neighbours.keys.toList()
        ..sort((a, b) => a.id.compareTo(b.id));

      await Future.delayed(const Duration(milliseconds: 100));
      for (final neighbour in neighbours) {
        if (!seen.contains(neighbour)) {
          see(neighbour);
        }
      }
    }
  }

  void see(Vertex vertex) {
    print("Seeing ${vertex.label}");
    stack.push(vertex);
    seen.add(vertex);
    vertex.component.paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
  }

  void visit(Vertex vertex) {
    print("Visiting ${vertex.label}");
    visited.add(vertex);
    vertex.component.paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
  }
}
