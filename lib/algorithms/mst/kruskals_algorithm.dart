import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/mst/mst.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/data_structures/union_find.dart';

class KruskalsAlgorithm extends MinimumSpanningTree {
  ColoredUnionFind<Vertex> unionFind = ColoredUnionFind();
  List<Edge> edges = [];

  @override
  void start() async {
    initialize();
    edges = graph.edges..sort((a, b) => a.weight.compareTo(b.weight));

    for (var edge in edges) {
      await checkEdge(currentEdge.value = edge);
    }

    finalize();
  }

  bool makesCycle(Edge edge) {
    return unionFind.find(edge.from).first == unionFind.find(edge.to).first;
  }

  Future checkEdge(Edge edge) async {
    await Future.delayed(const Duration(milliseconds: 500));
    edge.component
      ..edgeWidth += 2
      ..setColors(Colors.white, Colors.white);
    edge.from.component
      ..radius = Globals.defaultVertexRadius + 5
      ..drawBorder = true;

    edge.to.component
      ..radius = Globals.defaultVertexRadius + 5
      ..drawBorder = true;

    await Future.delayed(const Duration(milliseconds: 500));

    edge.component.edgeWidth = Globals.defaultEdgeWidth;
    edge.from.component
      ..radius = Globals.defaultVertexRadius
      ..drawBorder = false;
    edge.to.component
      ..radius = Globals.defaultVertexRadius
      ..drawBorder = false;

    if (!edge.isSelfEdge && !makesCycle(edge)) {
      includeEdge(edge);
    } else {
      edge.component.setColors(Colors.black, Colors.black);
    }

    updateColors();
  }

  void includeEdge(Edge edge) {
    unionFind.union(edge.from, edge.to);
    includedEdges.add(edge);
    weightNotifier.value += edge.weight;
  }

  void updateColors() {
    for (var edge in includedEdges.set) {
      var color = unionFind.find(edge.from).second ?? Colors.white;
      edge.component.setColors(color, color);
      edge.from.component.setColors(color, color);
      edge.to.component.setColors(color, color);
    }
  }

  @override
  void clear() {
    super.clear();
    edges.clear();
    unionFind.clear();
  }
}
