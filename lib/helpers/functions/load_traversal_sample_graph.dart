import 'package:flame/components.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';

void loadTraversalSampleGraph() {
  Globals.game.clearGraph();

  Globals.game.graph.addVertex(
    Vertex(
      label: "A",
      position: Vector2(0, -150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "B",
      position: Vector2(-200, -50),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "C",
      position: Vector2(200, -50),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "D",
      position: Vector2(-300, 50),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "E",
      position: Vector2(-100, 50),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "F",
      position: Vector2(100, 50),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "G",
      position: Vector2(300, 50),
    ),
  );

  Globals.game.graph.addVertex(
    Vertex(
      label: "H",
      position: Vector2(-350, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "I",
      position: Vector2(-250, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "J",
      position: Vector2(-150, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "K",
      position: Vector2(-50, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "L",
      position: Vector2(50, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "M",
      position: Vector2(150, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "N",
      position: Vector2(250, 150),
    ),
  );
  Globals.game.graph.addVertex(
    Vertex(
      label: "O",
      position: Vector2(350, 150),
    ),
  );

  // Edges
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[0],
      to: Globals.game.graph.vertices[1],
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[0],
      to: Globals.game.graph.vertices[2],
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[1],
      to: Globals.game.graph.vertices[3],
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[1],
      to: Globals.game.graph.vertices[4],
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[2],
      to: Globals.game.graph.vertices[5],
    ),
  );
  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[2],
      to: Globals.game.graph.vertices[6],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[3],
      to: Globals.game.graph.vertices[7],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[3],
      to: Globals.game.graph.vertices[8],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[4],
      to: Globals.game.graph.vertices[9],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[4],
      to: Globals.game.graph.vertices[10],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[5],
      to: Globals.game.graph.vertices[11],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[5],
      to: Globals.game.graph.vertices[12],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[6],
      to: Globals.game.graph.vertices[13],
    ),
  );

  Globals.game.graph.addEdge(
    Edge(
      from: Globals.game.graph.vertices[6],
      to: Globals.game.graph.vertices[14],
    ),
  );

  Globals.game.refreshGraphComponents();
}
