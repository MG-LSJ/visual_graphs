import 'dart:async';
import 'dart:ui' as ui;

import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/graph_game.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/widgets/vertex_info_box.dart';

class VertexComponent extends ShapeComponent
    with
        TapCallbacks,
        HoverCallbacks,
        // DragCallbacks,
        HasGameRef<GraphGame>,
        CollisionCallbacks
    implements
        SizeProvider {
  Vertex vertex;

  double radius = Globals.defaultVertexRadius;
  double _circleRadius = Globals.defaultVertexRadius;

  Color color = Globals.defaultVertexColor;
  Color hoverColor = Globals.deafultVertexHoverColor;
  Color borderColor = Colors.white;

  Color _paintColor = Globals.defaultVertexColor;
  final PaintingStyle _paintPaintingStyle = PaintingStyle.fill;

  bool drawBorder = false;

  VertexComponent(position, {required this.vertex})
      : super(
          position: position,
          anchor: Anchor.center,
        ) {
    width = radius * 2;
    height = radius * 2;

    paint = Paint();
  }

  void setColors(Color color, Color hoverColor) {
    this.color = color;
    this.hoverColor = hoverColor;
    onHoverExit();
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
    if (gameRef.gameMode == GameMode.defaultMode) {
      showInfo(gameRef.editorWidgetContext);
    }
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
        _paintColor = hoverColor;
        _circleRadius = radius + 2;
        gameRef.mouseCursor = SystemMouseCursors.click;
        break;
      case GameMode.deleteComponent:
        _paintColor = Globals.defaultDeleteColor;
        _circleRadius = radius + 2;
        gameRef.mouseCursor = SystemMouseCursors.click;
        drawBorder = true;
        break;
      case GameMode.addEdge:
        _paintColor = hoverColor;
        _circleRadius = radius + 2;
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
        drawBorder = false;
        break;
      default:
    }
    _circleRadius = radius;
    _paintColor = color;
    super.onHoverExit();
  }

  @override
  void render(Canvas canvas) {
    if (drawBorder) {
      canvas.drawCircle(
        Offset(width / 2, height / 2),
        _circleRadius + 1,
        paint
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }

    canvas.drawCircle(
      Offset(width / 2, height / 2),
      _circleRadius,
      paint
        ..color = _paintColor
        ..style = _paintPaintingStyle,
    );
    renderText(canvas);
  }

  void renderText(Canvas canvas) {
    const paragraphFontSize = Globals.defaultVertexFontSize;
    const fontSize = paragraphFontSize + 2;
    const fontWeight = FontWeight.normal;
    const fontColor = Globals.defualtVertexFontColor;
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
        style: const TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        text: text,
      ),
    )..layout();

    paragraph.layout(ui.ParagraphConstraints(width: hpainter.width));

    canvas.drawParagraph(
      paragraph,
      ui.Offset(
        width / 2 - hpainter.width / 2,
        height / 2 - hpainter.height / 2,
      ),
    );
  }
}
