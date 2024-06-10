import 'package:visual_graphs/graph_editor/components/edge_component.dart';
import 'package:visual_graphs/graph_editor/components/vertex_component.dart';
import 'package:flame/components.dart';

part "edge.dart";
part "vertex.dart";

class Graph {
  late final Set<Vertex> _vertices;
  late final Set<Edge> _edges;
  late final Map<Vertex, Map<Vertex, Set<Edge>>> _edgesBetween;
  Vertex? hoveredVertex;
  Map<Edge, int> edgeIndexMap = {};
  Map<Edge, double> edgePositionedIndexMap = {};

  Graph() {
    _vertices = {};
    _edges = {};
    _edgesBetween = {};
  }

  List<Vertex> get vertices => _vertices.toList();
  List<Edge> get edges => _edges.toList();

  void addVertex(Vertex vertex) {
    _vertices.add(vertex);
  }

  void addEdge(Edge edge) {
    insertEdgeInCache(edge.from, edge.to, edge);

    // If edge is not directed, add it in reverse too
    if (!edge.isDirected && !edge.isSelfEdge) {
      insertEdgeInCache(edge.to, edge.from, edge);
    }
    _edges.add(edge);
  }

  void removeVertex(Vertex vertex) {
    _vertices.remove(vertex);
    var edgesToRemove = _edges
        .where((edge) => edge.from == vertex || edge.to == vertex)
        .toList();
    for (var edge in edgesToRemove) {
      removeEdge(edge);
    }
  }

  void removeEdge(Edge edge) {
    _edges.remove(edge);
  }

  void insertEdgeInCache(Vertex from, Vertex to, Edge edge) {
    if (_edgesBetween.containsKey(from)) {
      // If there is already an edge between the two vertices
      if (_edgesBetween[from]!.containsKey(to)) {
        // Add the new edge to the list of edges between the two vertices
        _edgesBetween[from]![to]!.add(edge);
      } else {
        // Create a new list of edges between the two vertices
        _edgesBetween[from]![to] = {edge};
      }
    } else {
      // Create a new map of edges between the two vertices
      _edgesBetween[from] = {
        to: {edge}
      };
    }
  }

  void removeEdgeFromCache(Edge edge) {
    if (_edgesBetween.containsKey(edge.from)) {
      if (_edgesBetween[edge.from]!.containsKey(edge.to)) {
        _edgesBetween[edge.from]![edge.to]!.remove(edge);

        // If there are no more edges between the two vertices, remove the key
        if (_edgesBetween[edge.from]![edge.to]!.isEmpty) {
          _edgesBetween[edge.from]!.remove(edge.to);
        }
      }
    }

    if (!edge.isDirected && !edge.isSelfEdge) {
      if (_edgesBetween.containsKey(edge.to)) {
        if (_edgesBetween[edge.to]!.containsKey(edge.from)) {
          _edgesBetween[edge.to]![edge.from]!.remove(edge);

          // If there are no more edges between the two vertices, remove the key
          if (_edgesBetween[edge.to]![edge.from]!.isEmpty) {
            _edgesBetween[edge.to]!.remove(edge.from);
          }
        }
      }
    }
  }

  void clear() {
    _vertices.clear();
    _edges.clear();
  }

  Map<Vertex, Set<Edge>> getNeighbours(Vertex vertex) =>
      _edgesBetween[vertex] ?? {};

  List<Edge> getEdgesBetween(Vertex start, Vertex? end) {
    if (end == null) return [];

    Set<Edge> edges = {};
    if (_edgesBetween.containsKey(start)) {
      if (_edgesBetween[start]!.containsKey(end)) {
        edges.addAll(_edgesBetween[start]![end]!);
      }
    }
    if (_edgesBetween.containsKey(end)) {
      if (_edgesBetween[end]!.containsKey(start)) {
        edges.addAll(_edgesBetween[end]![start]!);
      }
    }
    var list = edges.toList();
    return list;
  }

  Vector2 get geometricCenter {
    if (_vertices.isEmpty) {
      return Vector2.zero();
    }

    var x = 0.0;
    var y = 0.0;
    for (var vertex in _vertices) {
      x += vertex.component.position.x;
      y += vertex.component.position.y;
    }

    return Vector2(x / _vertices.length, y / _vertices.length);
  }

  void computeEdgeIndex() {
    edgeIndexMap.clear();
    for (var edge in _edges) {
      edgeIndexMap[edge] = edge.computeIndex();
    }
  }

  void computeEdgePositionedIndex() {
    for (var edge in _edges) {
      edgePositionedIndexMap[edge] = edge.computePositionedIndex();
    }
  }

  bool get isEmpty => _vertices.isEmpty;
  bool get isNotEmpty => _vertices.isNotEmpty;

  Graph._from(
    this._vertices,
    this._edges,
    this._edgesBetween,
    this.edgeIndexMap,
    this.edgePositionedIndexMap,
  );

  Graph clone() {
    return Graph._from(
      Set.from(_vertices),
      Set.from(_edges),
      Map.from(_edgesBetween),
      Map.from(edgeIndexMap),
      Map.from(edgePositionedIndexMap),
    );
  }
}
