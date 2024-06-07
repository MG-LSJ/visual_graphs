import 'package:visual_graphs/components/half_edge_component.dart';
import 'package:visual_graphs/models/graph.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum GameMode {
  defaultMode,
  addVertex,
  addEdge,
  deleteComponent,
}

class GraphGame extends FlameGame
    with PanDetector, TapCallbacks, MouseMovementDetector, KeyboardEvents {
  late Graph graph;

  GameMode _gameMode = GameMode.defaultMode;
  GameMode get gameMode => _gameMode;
  late BuildContext context;
  late State parentWidgetState;

  GraphGame() {
    graph = Graph();
    graph.addVertex(Vertex(label: "0", position: Vector2(-100, -100)));
    graph.addVertex(Vertex(label: "1", position: Vector2(100, 100)));
    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[1],
      weight: 10,
    ));
    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[0],
      weight: 5,
    ));
    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[0],
      weight: 10,
      isDirected: true,
    ));
    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[1],
      weight: 5,
      isDirected: true,
    ));
  }

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    camera = CameraComponent(world: world);
    camera.viewfinder.anchor = Anchor.center;
    add(camera);
    refreshGraphComponents();
  }

  void refreshGraphComponents() {
    // ignore: invalid_use_of_internal_member
    world.children.clear();
    for (var edge in graph.edges) {
      world.add(edge.component);
    }
    for (var vertex in graph.vertices) {
      world.add(vertex.component);
    }

    graph
      ..computeEdgeIndex()
      ..computeEdgePositionedIndex();
  }

  Vector2 cursorPosition = Vector2.zero();
  @override
  void onMouseMove(PointerHoverInfo info) {
    cursorPosition = info.eventPosition.global;
    switch (gameMode) {
      case GameMode.defaultMode:
      case GameMode.deleteComponent:
        for (var edge in graph.edges) {
          if (graph.hoveredVertex == null &&
              edge.component.checkHover(cursorPosition)) {
            edge.component.hoverIn();
          } else {
            edge.component.hoverOut();
          }
        }
        break;
      default:
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (gameMode == GameMode.defaultMode ||
        gameMode == GameMode.deleteComponent) {
      if (graph.hoveredVertex != null) {
        graph.hoveredVertex!.component.position += info.delta.global;
      } else {
        camera.viewfinder.position -= info.delta.global;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (gameMode) {
      case GameMode.addVertex:
        addVertex(event);
        event.handled = true;
        break;
      case GameMode.deleteComponent:
        for (var edge in graph.edges) {
          if (edge.component.checkHover(cursorPosition)) {
            graph.removeEdge(edge);
            refreshGraphComponents();
            break;
          }
        }
        break;
      default:
    }
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    switch (gameMode) {
      case GameMode.defaultMode:
        for (var edge in graph.edges) {
          if (edge.component.checkHover(cursorPosition)) {
            edge.component.showInfo(context);
            break;
          }
        }
      default:
    }
  }

  void addVertex(TapDownEvent event) {
    // Convert the global tap position to the local position of the camera viewfinder
    var position = camera.viewfinder.globalToLocal(event.localPosition);
    graph.addVertex(Vertex(
      position: position,
      label: graph.vertices.length.toString(),
    ));
    refreshGraphComponents();
  }

  void deleteVertex(Vertex v) {
    graph.removeVertex(v);
    refreshGraphComponents();
  }

  Vertex? selectedVertex;
  void addEdge(Vertex v) {
    if (selectedVertex == null) {
      selectedVertex = v;
      world.add(HalfEdgeComponent(v.component));
    } else {
      graph.addEdge(Edge(from: selectedVertex!, to: v));
      selectedVertex = null;
      refreshGraphComponents();
    }
  }

  set gameMode(GameMode gm) {
    _gameMode = gm;
    selectedVertex = null;
    switch (gm) {
      case GameMode.addVertex:
        mouseCursor = SystemMouseCursors.precise;
        break;
      case GameMode.addEdge:
        mouseCursor = SystemMouseCursors.precise;
        break;
      default:
        mouseCursor = SystemMouseCursors.basic;
    }
    refreshGraphComponents();
  }

  void clearGraph() {
    graph.clear();
    refreshGraphComponents();
  }

  void centerCamera() => camera.viewfinder.position = graph.center;

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      switch (gameMode) {
        case GameMode.addVertex:
        case GameMode.deleteComponent:
          gameMode = GameMode.defaultMode;
          break;
        case GameMode.addEdge:
          if (selectedVertex != null) {
            selectedVertex = null;
            refreshGraphComponents();
          } else {
            gameMode = GameMode.defaultMode;
          }
          break;
        default:
      }
      // ignore: invalid_use_of_protected_member
      parentWidgetState.setState(() {});
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyC)) {
      centerCamera();
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
      gameMode = GameMode.addEdge;
      // ignore: invalid_use_of_protected_member
      parentWidgetState.setState(() {});
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyV)) {
      gameMode = GameMode.addVertex;
      // ignore: invalid_use_of_protected_member
      parentWidgetState.setState(() {});
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyX)) {
      gameMode = GameMode.deleteComponent;
      // ignore: invalid_use_of_protected_member
      parentWidgetState.setState(() {});
      return KeyEventResult.handled;
    }

    // camera movement
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      camera.viewfinder.position += Vector2(0, 10);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS)) {
      camera.viewfinder.position += Vector2(0, -10);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      camera.viewfinder.position += Vector2(10, 0);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      camera.viewfinder.position += Vector2(-10, 0);
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
