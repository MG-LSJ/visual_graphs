import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/graph_game.dart';

abstract class Globals {
  static late final GraphGame game;

  static const Color backgroundColor = Color(0xFF211F30);
  static const Color defaultTextColor = Color(0xFFFFFFFF);

  static const Color defaultVertexColor = Colors.blue;
  static const Color deafultVertexHoverColor = Colors.lightBlue;
  static const Color defualtVertexFontColor = Colors.white;
  static const double defaultVertexRadius = 20;
  static const double defaultVertexFontSize = 14;

  static const Color defaultEdgeColor = Colors.white;
  static const Color defaultEdgeHoverColor = Colors.white;
  static const double defaultEdgeWidth = 2;
  static const double defaultEdgeHoverWidth = 3;

  static const Color defaultDeleteColor = Colors.red;
}

enum GameMode {
  lockedMode,
  defaultMode,
  addVertex,
  addEdge,
  deleteComponent,
  pickVertex,
}
