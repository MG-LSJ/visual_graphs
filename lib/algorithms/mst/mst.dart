import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/algorithm.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/notifiers/set_notifier.dart';

class MinimumSpanningTree extends Algorithm {
  final ValueNotifier<int> weightNotifier = ValueNotifier<int>(0);
  final SetNotifier<Edge> includedEdges = SetNotifier<Edge>();
  ValueNotifier<Edge?> currentEdge = ValueNotifier<Edge?>(null);
  int edgeCount = 0;

  @override
  void clear() {
    super.clear();
    includedEdges.clear();
    currentEdge.value = null;
    weightNotifier.value = 0;
    edgeCount = 0;
  }

  @override
  void finalize() {
    super.finalize();
    currentEdge.value = null;
  }
}
