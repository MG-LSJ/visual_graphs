part of "graph.dart";

abstract class _Vertex {
  static int _id = 0;

  final int id;
  String label;

  _Vertex({this.label = ''}) : id = _id++;

  @override
  String toString() {
    return "Vertex: $label, id: $id";
  }
}

class Vertex extends _Vertex {
  late final VertexComponent component;

  Vertex({super.label = '', Vector2? position}) {
    component = VertexComponent(position ?? Vector2.zero(), vertex: this);
  }

  Map<Vertex, Set<Edge>> get neighbours {
    return component.gameRef.graph.getNeighbours(this);
  }

  List<Vertex> get neighboursList {
    return neighbours.keys.toList();
  }
}
