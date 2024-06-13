import 'package:flame/components.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';

void loadMSTSampleGraph() {
  Globals.game.clearGraph();
  Globals.game.graph.addVertex(
    Vertex(
      label: "A",
      position: Vector2(-100, -200),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "B",
      position: Vector2(100, -200),
    ),
  );

  Globals.game.graph.addVertex(
    Vertex(
      label: "C",
      position: Vector2(-200, 0),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "D",
      position: Vector2(0, 0),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "E",
      position: Vector2(200, 0),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "F",
      position: Vector2(0, 200),
    ),
  );

  // edges

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[2],
      to: Globals.game.graph.vertices[0],
      weight: 1,
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[0],
      to: Globals.game.graph.vertices[1],
      weight: 1,
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[1],
      to: Globals.game.graph.vertices[4],
      weight: 6,
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[2],
      to: Globals.game.graph.vertices[3],
      weight: 5,
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[0],
      to: Globals.game.graph.vertices[3],
      weight: 4,
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[1],
      to: Globals.game.graph.vertices[3],
      weight: 4,
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[4],
      to: Globals.game.graph.vertices[3],
      weight: 5,
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[2],
      to: Globals.game.graph.vertices[5],
      weight: 6,
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[3],
      to: Globals.game.graph.vertices[5],
      weight: 2,
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[4],
      to: Globals.game.graph.vertices[5],
      weight: 8,
    ),
  );

  Globals.game.refreshGraphComponents();
}
