import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/data_structures/pair.dart';
import 'package:visual_graphs/helpers/material_color_generator.dart';
import 'package:visual_graphs/helpers/notifiers/set_notifier.dart';

class Kruskal {
  int weight = 0;
  UnionFind<Vertex> unionFind = UnionFind();
  final SetNotifier<Edge> includedEdges = SetNotifier<Edge>();
  ValueNotifier<Edge?> currentEdge = ValueNotifier<Edge?>(null);

  void start() async {
    greyOut();
    updateColors();

    List<Edge> edges = Globals.game.graph.edges
      ..sort((a, b) => a.weight.compareTo(b.weight));

    for (var edge in edges) {
      await Future.delayed(const Duration(milliseconds: 500));
      await checkEdge(currentEdge.value = edge);
    }
    currentEdge.value = null;
  }

  bool makesCycle(Edge edge) {
    return unionFind.find(edge.from).first == unionFind.find(edge.to).first;
  }

  Future checkEdge(Edge edge) async {
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
    weight += edge.weight;
  }

  void updateColors() {
    for (var edge in includedEdges.set) {
      var color = unionFind.find(edge.from).second ?? Colors.white;
      edge.component.setColors(color, color);
      edge.from.component.setColors(color, color);
      edge.to.component.setColors(color, color);
    }
  }

  void greyOut() {
    for (var vertex in Globals.game.graph.vertices) {
      vertex.component.setColors(Colors.grey.shade800, Colors.grey.shade800);
    }
    for (var edge in Globals.game.graph.edges) {
      edge.component.setColors(Colors.grey.shade800, Colors.grey.shade800);
    }
  }

  void clear() {
    weight = 0;
    unionFind.clear();
    includedEdges.clear();
  }
}

class UnionFind<T> {
  final MaterialColorGenerator materialColorGenerator =
      MaterialColorGenerator();

  Map<T, Pair<T, Color?>> parent = {};

  union(T a, T b) {
    var aParent = find(a);
    var bParent = find(b);

    if (aParent.first == bParent.first) {
      return;
    }

    switch ((aParent.second != null, bParent.second != null)) {
      case (true, true):
        parent[aParent.first] = bParent;
        break;
      case (true, false):
        parent[bParent.first] = aParent;
        break;
      case (false, true):
        parent[aParent.first] = bParent;
        break;
      case (false, false):
        var color = materialColorGenerator.next();
        parent[aParent.first] = Pair(bParent.first, color);
        parent[bParent.first] = Pair(bParent.first, color);
        break;
    }
  }

  Pair<T, Color?> find(T a) {
    if (parent[a] == null) {
      parent[a] = Pair(a, null);
      return parent[a]!;
    } else {
      if (parent[a]!.first == a) {
        return parent[a]!;
      } else {
        return parent[a] = find(parent[a]!.first);
      }
    }
  }

  void clear() {
    parent.clear();
  }
}
