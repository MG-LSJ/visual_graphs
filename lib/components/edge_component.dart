import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:visual_graphs/components/graph_game.dart';
import 'package:visual_graphs/models/graph.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EdgeComponent extends ShapeComponent with HasGameRef<GraphGame> {
  Edge edge;
  Color color = Colors.white;
  Color hoverColor = Colors.white;
  Color _color = const Color(0x00000000);
  Path path = Path();
  double labelTextSize = 14;
  List<Offset> pathPoints = [];

  EdgeComponent(this.edge) {
    _color = color;
    anchor = Anchor.topLeft;
    position = edge.from.component.position;
    paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
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
      builder: (BuildContext context) {
        return EdgeInfoBox(edgeComponent: this);
      },
    );
  }

  void hoverIn() {
    _color =
        gameRef.gameMode == GameMode.deleteComponent ? Colors.red : hoverColor;
    paint
      ..color = _color
      ..strokeWidth = 3;
    labelTextSize = 16;
  }

  void hoverOut() {
    _color = color;
    paint
      ..color = _color
      ..strokeWidth = 2;
    labelTextSize = 14;
  }

  // rendering
  @override
  void render(Canvas canvas) {
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
      var tangent = metric
          .getTangentForOffset(metric.length - edge.from.component.radius)!;
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

    var center = gameRef.graph.center;
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
    var fontColor = _color;
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
        ..color = const Color(0xFF211F30)
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

class EdgeInfoBox extends StatefulWidget {
  final EdgeComponent edgeComponent;
  const EdgeInfoBox({super.key, required this.edgeComponent});

  @override
  State<EdgeInfoBox> createState() => _EdgeInfoBoxState();
}

class _EdgeInfoBoxState extends State<EdgeInfoBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(
          "Edge: Node ${widget.edgeComponent.edge.from.label} ${widget.edgeComponent.edge.isDirected ? "to" : "&"} Node ${widget.edgeComponent.edge.to.label}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("ID: ${widget.edgeComponent.edge.id}"),
          TextField(
            decoration: const InputDecoration(
              labelText: "Weight",
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(
                text: widget.edgeComponent.edge.weight.toString()),
            focusNode: FocusNode()..requestFocus(),
            onChanged: (value) {
              if (value.isEmpty) {
                widget.edgeComponent.edge.weight = 0;
              }
              try {
                widget.edgeComponent.edge.weight = int.parse(value);
              } catch (e) {
                return;
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
            ],
          ),
          CheckboxListTile(
            title: const Text("Directed"),
            value: widget.edgeComponent.edge.isDirected,
            onChanged: (value) => setState(() {
              widget.edgeComponent.gameRef.graph
                  .removeEdge(widget.edgeComponent.edge);
              widget.edgeComponent.edge.isDirected = value!;
              widget.edgeComponent.gameRef.graph
                  .addEdge(widget.edgeComponent.edge);
            }),
          ),
          if (widget.edgeComponent.edge.isDirected)
            ElevatedButton.icon(
              onPressed: () {
                widget.edgeComponent.gameRef.graph
                    .removeEdge(widget.edgeComponent.edge);

                // swap the vertices
                var temp = widget.edgeComponent.edge.from;
                widget.edgeComponent.edge.from = widget.edgeComponent.edge.to;
                widget.edgeComponent.edge.to = temp;

                widget.edgeComponent.gameRef.graph
                    .addEdge(widget.edgeComponent.edge);
                setState(() {});
              },
              label: const Text("Reverse"),
              icon: const Icon(Icons.swap_horiz_outlined),
            ),
        ],
      ),
    );
  }
}
