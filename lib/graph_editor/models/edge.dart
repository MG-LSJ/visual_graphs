part of "graph.dart";

abstract class _Edge {
  static int _id = 0;
  late final int id;

  Vertex from;
  Vertex to;
  int weight = 0;
  bool isSelfEdge;
  bool isDirected;

  _Edge({
    required this.from,
    required this.to,
    this.weight = 0,
    this.isDirected = false,
  })  : isSelfEdge = from == to,
        id = _id++;

  @override
  String toString() {
    return "Edge($id): ${from.label} -> ${to.label} ${isDirected ? "Directed" : "Undirected"} ${isSelfEdge ? "Self" : ""} Weight: $weight";
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    if (other is _Edge) {
      return id == other.id;
    }
    return false;
  }
}

class Edge extends _Edge {
  late final EdgeComponent component;

  Edge(
      {required super.from,
      required super.to,
      super.weight,
      super.isDirected = false}) {
    component = EdgeComponent(this);
  }

  double computePositionedIndex() {
    var edgeList = component.gameRef.graph.getEdgesBetween(from, to);
    edgeList.sort((a, b) => a.id.compareTo(b.id));
    var index = edgeList.indexOf(this);

    switch ((edgeList.length.isEven, index.isEven)) {
      case (true, true):
        return 0.5 + index ~/ 2;
      case (true, false):
        return -(0.5 + index ~/ 2);
      case (false, true):
        return index ~/ 2 + 0.0;
      case (false, false):
        return -(index ~/ 2 + 1.0);
    }
  }

  double get positionedIndex {
    if (component.gameRef.graph.edgePositionedIndexMap[this] == null) {
      component.gameRef.graph.computeEdgePositionedIndex();
    }
    return component.gameRef.graph.edgePositionedIndexMap[this]!;
  }

  int computeIndex() {
    var edgeList = component.gameRef.graph.getEdgesBetween(from, to);
    edgeList.sort((a, b) => a.id.compareTo(b.id));
    var index = edgeList.indexOf(this);
    return index;
  }

  int get index {
    if (component.gameRef.graph.edgeIndexMap[this] == null) {
      component.gameRef.graph.computeEdgeIndex();
    }
    return component.gameRef.graph.edgeIndexMap[this]!;
  }
}
