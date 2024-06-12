import 'package:visual_graphs/graph_editor/components/half_edge_component.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/graph_editor.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visual_graphs/helpers/data_structures/stack.dart';

class GraphGame extends FlameGame
    with PanDetector, TapCallbacks, MouseMovementDetector, KeyboardEvents {
  late Graph graph;

  GameMode _gameMode = GameMode.lockedMode;
  GameMode _previousGameMode = GameMode.lockedMode;
  GameMode get gameMode => _gameMode;

  bool addEdgeModeIsWeighted = false;
  bool addEdgeModeIsDirected = false;

  late BuildContext editorWidgetContext;
  final State<GraphEditorWidget> editorWidgetState;

  SizedStackDS<Graph> undoStack = SizedStackDS(10);

  GraphGame({required this.editorWidgetState}) {
    graph = Graph();
    // initiaize graph with some vertices and edges
    graph.addVertex(Vertex(label: "0", position: Vector2(-100, -100)));
    graph.addVertex(Vertex(label: "1", position: Vector2(100, 100)));
    graph.addVertex(Vertex(label: "2", position: Vector2(100, -100)));
    graph.addVertex(Vertex(label: "3", position: Vector2(-100, 100)));

    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[1],
      weight: 5,
    ));
    graph.addEdge(Edge(
        from: graph.vertices[1],
        to: graph.vertices[2],
        weight: 3,
        isDirected: true));
    graph.addEdge(Edge(
      from: graph.vertices[1],
      to: graph.vertices[3],
      weight: 1,
    ));
    graph.addEdge(Edge(
      from: graph.vertices[3],
      to: graph.vertices[0],
      isDirected: true,
    ));
    graph.addEdge(Edge(
      from: graph.vertices[0],
      to: graph.vertices[0],
      weight: 2,
      isDirected: true,
    ));
  }

  @override
  Color backgroundColor() => Globals.backgroundColor;

  @override
  Future<void> onLoad() async {
    camera = CameraComponent(world: world);
    camera.viewfinder.anchor = Anchor.center;
    add(camera);
    refreshGraphComponents();
  }

  void resetGraphColors() {
    for (var edge in graph.edges) {
      edge.component.setColors(
        Globals.defaultEdgeColor,
        Globals.defaultEdgeHoverColor,
      );
    }
    for (var vertex in graph.vertices) {
      vertex.component.setColors(
        Globals.defaultVertexColor,
        Globals.deafultVertexHoverColor,
      );
    }
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
    if (gameMode == GameMode.lockedMode) {
      camera.viewfinder.position -= info.delta.global;
      return;
    }

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
            saveHistory();
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
            edge.component.showInfo(editorWidgetContext);
            break;
          }
        }
      default:
    }
  }

  void addVertex(TapDownEvent event) {
    saveHistory();

    // Convert the global tap position to the local position of the camera viewfinder
    var position = camera.viewfinder.globalToLocal(event.localPosition);
    graph.addVertex(Vertex(
      position: position,
      label: graph.vertices.length.toString(),
    ));
    refreshGraphComponents();
  }

  void deleteVertex(Vertex v) {
    saveHistory();

    graph.removeVertex(v);
    refreshGraphComponents();
  }

  Vertex? selectedVertex;
  void addEdge(Vertex v) {
    if (selectedVertex == null) {
      selectedVertex = v;
      world.add(HalfEdgeComponent(v.component));
    } else {
      saveHistory();

      var edge = Edge(
        from: selectedVertex!,
        to: v,
        isDirected: addEdgeModeIsDirected,
      );
      graph.addEdge(edge);
      selectedVertex = null;
      refreshGraphComponents();
      if (addEdgeModeIsWeighted) {
        edge.component.showInfo(editorWidgetContext);
      }
    }
  }

  set gameMode(GameMode gm) {
    _previousGameMode = _gameMode;
    _gameMode = gm;
    selectedVertex = null;
    switch (gm) {
      case GameMode.addVertex:
        mouseCursor = SystemMouseCursors.precise;
        break;
      case GameMode.addEdge:
        mouseCursor = SystemMouseCursors.precise;
        break;
      case GameMode.lockedMode:
        mouseCursor = SystemMouseCursors.grab;
        undoStack.clear();
        break;
      case GameMode.deleteComponent:
        mouseCursor = SystemMouseCursors.click;
        break;
      case GameMode.pickVertex:
        mouseCursor = SystemMouseCursors.precise;
        break;
      case GameMode.defaultMode:
        mouseCursor = SystemMouseCursors.basic;
    }
    editorWidgetState.setState(() {});
    refreshGraphComponents();
  }

  void restorePreviousGameMode() {
    gameMode = _previousGameMode;
  }

  void clearGraph() {
    saveHistory();
    graph.clear();
    refreshGraphComponents();
  }

  void saveHistory() {
    // ignore: invalid_use_of_protected_member
    editorWidgetState.setState(() {});
    undoStack.push(graph.clone());
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      graph = undoStack.pop();
      refreshGraphComponents();
    }
  }

  void centerCamera() {
    camera.viewfinder.position = graph.geometricCenter;
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (gameMode != GameMode.lockedMode) {
      if (keysPressed.contains(LogicalKeyboardKey.controlLeft) ||
          keysPressed.contains(LogicalKeyboardKey.controlRight)) {
        if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
          undo();
          // ignore: invalid_use_of_protected_member
          editorWidgetState.setState(() {});
          return KeyEventResult.handled;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
          gameMode = GameMode.lockedMode;
          // ignore: invalid_use_of_protected_member
          editorWidgetState.setState(() {});
          return KeyEventResult.handled;
        }
      }

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
          case GameMode.pickVertex:
            restorePreviousGameMode();
            break;
          default:
        }
        return KeyEventResult.handled;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
        gameMode = GameMode.addEdge;
        return KeyEventResult.handled;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyV)) {
        gameMode = GameMode.addVertex;
        return KeyEventResult.handled;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyX)) {
        gameMode = GameMode.deleteComponent;
        return KeyEventResult.handled;
      }
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyC)) {
      centerCamera();
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
