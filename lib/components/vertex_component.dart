import 'dart:async';
import 'dart:ui' as ui;

import 'package:visual_graphs/components/graph_game.dart';
import 'package:visual_graphs/models/graph.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/widgets/vertex_info_box.dart';

class VertexComponent extends ShapeComponent
    with
        TapCallbacks,
        HoverCallbacks,
        // DragCallbacks,
        HasGameRef<GraphGame>,
        CollisionCallbacks
    implements
        SizeProvider {
  double radius = 20;
  double circleRadius = 20;
  Color color = Colors.blue;
  Color hoverColor = Colors.lightBlue;
  Vertex vertex;

  VertexComponent(position, {required this.vertex})
      : super(
          position: position,
          anchor: Anchor.center,
        ) {
    width = radius * 2;
    height = radius * 2;
    paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // debugMode = true;
  }

  @override
  FutureOr<void> onLoad() {}

  @override
  void onTapDown(TapDownEvent event) {
    switch (gameRef.gameMode) {
      case GameMode.addEdge:
        gameRef.addEdge(vertex);
        break;
      case GameMode.deleteComponent:
        gameRef.deleteVertex(vertex);
        break;
      default:
    }
    event.handled = true;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    event.handled = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    event.handled = true;
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    showInfo(gameRef.context);
    event.handled = true;
  }

  void showInfo(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return VertexInfoBox(vertexComponent: this);
      },
    );
  }

  @override
  void onHoverEnter() {
    gameRef.graph.hoveredVertex = vertex;
    switch (gameRef.gameMode) {
      case GameMode.defaultMode:
        paint = Paint()
          ..color = hoverColor
          ..style = PaintingStyle.fill;
        circleRadius = radius + 2;
        gameRef.mouseCursor = SystemMouseCursors.click;
        break;
      case GameMode.deleteComponent:
        paint = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill;
        circleRadius = radius + 2;
        gameRef.mouseCursor = SystemMouseCursors.click;
        break;
      case GameMode.addEdge:
        paint = Paint()
          ..color = hoverColor
          ..style = PaintingStyle.fill;
        circleRadius = radius + 2;
        break;
      default:
    }
    return super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    gameRef.graph.hoveredVertex = null;
    switch (gameRef.gameMode) {
      case GameMode.defaultMode:
      case GameMode.deleteComponent:
        gameRef.mouseCursor = SystemMouseCursors.basic;
        break;
      default:
    }
    circleRadius = radius;
    paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    super.onHoverExit();
  }

  // Rendering

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(radius, radius),
      circleRadius,
      paint,
    );
    renderText(canvas);
  }

  void renderText(Canvas canvas) {
    var paragraphFontSize = 14.0;
    var fontSize = paragraphFontSize + 2;
    var fontWeight = FontWeight.normal;
    var fontColor = Colors.white;
    var text = vertex.label;

    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        fontSize: paragraphFontSize,
        fontWeight: fontWeight,
      ),
    );

    ui.TextStyle textStyle = ui.TextStyle(
      fontSize: fontSize,
      foreground: Paint()..color = fontColor,
      fontWeight: fontWeight,
    );

    paragraphBuilder
      ..pushStyle(textStyle)
      ..addText(text);

    final paragraph = paragraphBuilder.build();

    TextPainter hpainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        text: text,
      ),
    )..layout();

    paragraph.layout(ui.ParagraphConstraints(width: hpainter.width));

    canvas.drawParagraph(
      paragraph,
      ui.Offset(radius - hpainter.width / 2, radius - hpainter.height / 2),
    );
  }
}
