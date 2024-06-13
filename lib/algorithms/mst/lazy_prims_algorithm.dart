import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/mst/mst.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/notifiers/priority_queue_notifier.dart';

class LazyPrimsAlgorithm extends MinimumSpanningTree {
  final PriorityQueueNotifier<Edge> pq =
      PriorityQueueNotifier((a, b) => a.weight.compareTo(b.weight));

  final Set<Vertex> seen = {};
  final Set<Vertex> visited = {};

  @override
  void start([Vertex? startingVertex]) async {
    initialize();

    see(startingVertex!);
    await Future.delayed(const Duration(milliseconds: 500));
    await visit(startingVertex);

    while (pq.isNotEmpty && edgeCount < graph.vertices.length - 1) {
      await checkEdge(currentEdge.value = pq.removeFirst());
    }
    await Future.delayed(const Duration(seconds: 1));
    finalize();
  }

  Future visit(Vertex vertex) async {
    currentEdge.value = null;
    vertex.component.setColors(Colors.green, Colors.greenAccent);
    visited.add(vertex);
    await Future.delayed(const Duration(milliseconds: 100));
    addEdges(vertex);
  }

  void addEdges(Vertex vertex) {
    vertex.neighbours.forEach(
      (vertex, edges) {
        if (!visited.contains(vertex)) {
          for (var edge in edges) {
            edge.component.setColors(Colors.orange, Colors.orange);
            pq.add(edge);
          }
        }
        Future.delayed(const Duration(milliseconds: 100));
        see(vertex);
      },
    );
  }

  void see(Vertex vertex) {
    if (seen.contains(vertex)) return;
    seen.add(vertex);
    vertex.component.setColors(Colors.orange, Colors.orange);
  }

  Future checkEdge(Edge edge) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!visited.contains(currentEdge.value!.to)) {
      includeEdge(currentEdge.value!);
      await visit(currentEdge.value!.to);
    } else if (!edge.isDirected && !visited.contains(edge.from)) {
      // this is just becuase i don't represent undirected egde as two directed
      includeEdge(currentEdge.value!);
      await visit(currentEdge.value!.from);
    } else {
      excludeEdge(currentEdge.value!);
    }
  }

  void includeEdge(Edge edge) {
    edge.component.setColors(
      Colors.lightGreen,
      Colors.lightGreen,
    );

    weightNotifier.value += edge.weight;
    edgeCount++;
    includedEdges.add(edge);
  }

  void excludeEdge(Edge edge) {
    edge.component.setColors(
      Colors.black,
      Colors.black,
    );
    currentEdge.value = null;
  }

  @override
  void clear() {
    super.clear();
    pq.clear();
    seen.clear();
    visited.clear();
  }
}
