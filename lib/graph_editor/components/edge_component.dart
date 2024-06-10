import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/graph_game.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/widgets/edge_info_box.dart';

class EdgeComponent extends ShapeComponent with HasGameRef<GraphGame> {
  Edge edge;
  Color color = Globals.defaultEdgeColor;
  Color hoverColor = Globals.defaultEdgeHoverColor;

  Path path = Path();
  double labelTextSize = 14;
  List<Offset> pathPoints = [];

  Color _paintColor = const Color(0x00000000);
  final PaintingStyle _paintPaintingStyle = PaintingStyle.stroke;
  double _paintStrokeWidth = 2;

  EdgeComponent(this.edge) {
    _paintColor = color;
    anchor = Anchor.topLeft;
    position = edge.from.component.position;
  }

  void setColors(Color color, Color hoverColor) {
    this.color = color;
    this.hoverColor = hoverColor;
    hoverOut();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = edge.from.component.position;
  }

  bool checkHover(Vector2 cursorPosition) {
    cursorPosition = gameRef.camera.globalToLocal(cursorPosition);

    var cursorPoint = Offset(
      cursorPosition.x - edge.from.component.position.x,
      cursorPosition.y - edge.from.component.position.y,
    );

    for (var point in pathPoints) {
      if (Offset(point.dx - cursorPoint.dx, point.dy - cursorPoint.dy)
              .distance <
          5) {
        return true;
      }
    }
    return false;
  }

  void showInfo(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return EdgeInfoBox(edgeComponent: this);
      },
    );
  }

  void hoverIn() {
    _paintColor = gameRef.gameMode == GameMode.deleteComponent
        ? Globals.defaultDeleteColor
        : hoverColor;
    _paintStrokeWidth = 3;

    labelTextSize = 16;
  }

  void hoverOut() {
    _paintColor = color;
    _paintStrokeWidth = 2;

    labelTextSize = 14;
  }

  // rendering
  @override
  void render(Canvas canvas) {
    paint = Paint()
      ..color = _paintColor
      ..style = _paintPaintingStyle
      ..strokeWidth = _paintStrokeWidth;
    if (edge.isSelfEdge) {
      renderSelfEdge(canvas);
    } else {
      renderEdge(canvas);
    }
  }

  void renderEdge(Canvas canvas) {
    var startPoint = Offset.zero;

    var endPoint = Offset(
        edge.to.component.position.x - edge.from.component.position.x,
        edge.to.component.position.y - edge.from.component.position.y);

    var midPoint = Offset(
      endPoint.dx / 2,
      endPoint.dy / 2,
    );

    var index = edge.positionedIndex;
    if (edge.from.id > edge.to.id) {
      index = -index;
    }

    var perpendicularAngle = endPoint.direction + math.pi / 2;

    var normal = Offset.fromDirection(
        perpendicularAngle, index * (10000 / midPoint.distance).clamp(50, 100));

    normal = Offset(
      normal.dx + midPoint.dx,
      normal.dy + midPoint.dy,
    );

    path = Path();

    path.cubicTo(
      startPoint.dx,
      startPoint.dy,
      normal.dx,
      normal.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);

    var metric = path.computeMetrics().first;
    var offset = metric.length / 2;
    var pathCenter = metric.getTangentForOffset(offset)!.position;

    renderWeightText(
      canvas,
      pathCenter,
    );

    pathPoints = [];
    var lengthOffset = edge.from.component.radius * 1.5;
    for (double i = lengthOffset; i < metric.length - lengthOffset; i += 5) {
      var tangent = metric.getTangentForOffset(i)!;
      pathPoints.add(tangent.position);
    }

    if (edge.isDirected) {
      var tangent =
          metric.getTangentForOffset(metric.length - edge.to.component.radius)!;
      var directionArrowCenterOffset = tangent.position;
      var centerToEndOffset = Offset(
        directionArrowCenterOffset.dx - endPoint.dx,
        directionArrowCenterOffset.dy - endPoint.dy,
      );

      var pointA =
          Offset.fromDirection(centerToEndOffset.direction + math.pi / 6, 10) +
              directionArrowCenterOffset;
      var pointB =
          Offset.fromDirection(centerToEndOffset.direction - math.pi / 6, 10) +
              directionArrowCenterOffset;

      canvas.drawLine(directionArrowCenterOffset, pointA, paint);
      canvas.drawLine(directionArrowCenterOffset, pointB, paint);
    }
  }

  void renderSelfEdge(Canvas canvas) {
    var index = edge.index;
    var radius =
        (index + 1) * edge.from.component.radius * math.pow(0.975, index);
    path = Path();

    var center = gameRef.graph.geometricCenter;
    var centerOffset = Offset(
      center.x - edge.from.component.position.x,
      center.y - edge.from.component.position.y,
    );
    var angle = centerOffset.direction;
    // get coordinates of the center of the screen
    path.addArc(
      Rect.fromCircle(
        center: Offset.fromDirection(angle, -radius),
        radius: radius,
      ),
      0,
      2 * math.pi,
    );

    canvas.drawPath(path, paint);

    renderWeightText(
      canvas,
      Offset.fromDirection(angle, -2 * radius),
    );

    var metric = path.computeMetrics().first;
    pathPoints = [];
    for (double i = 0; i < metric.length; i += 5) {
      var tangent = metric.getTangentForOffset(i)!;
      pathPoints.add(tangent.position);
    }

    if (edge.isDirected) {
      var chord = edge.from.component.radius;

      Path p = Path()
        ..addArc(
          path.getBounds(),
          angle,
          2 * math.asin(chord / (2 * radius)),
        );
      var m = p.computeMetrics().first;

      var tangent = m.getTangentForOffset(m.length)!;
      var directionArrowCenterOffset = tangent.position;

      var pointA = Offset.fromDirection(-tangent.angle + math.pi / 6, 10) +
          directionArrowCenterOffset;
      var pointB = Offset.fromDirection(-tangent.angle - math.pi / 6, 10) +
          directionArrowCenterOffset;

      canvas.drawLine(directionArrowCenterOffset, pointA, paint);
      canvas.drawLine(directionArrowCenterOffset, pointB, paint);
    }
  }

  void renderWeightText(Canvas canvas, Offset offset) {
    if (edge.weight == 0) {
      return;
    }

    var paragraphFontSize = labelTextSize;
    var fontSize = paragraphFontSize + 2;
    var fontWeight = FontWeight.normal;
    var fontColor = _paintColor;
    var text = edge.weight.toString();

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

    canvas.drawCircle(
      offset,
      15,
      Paint()
        ..color = Globals.backgroundColor
        ..style = PaintingStyle.fill,
    );
    canvas.drawParagraph(
      paragraph,
      Offset(
        offset.dx - hpainter.width / 2,
        offset.dy - hpainter.height / 2,
      ),
    );
  }
}
