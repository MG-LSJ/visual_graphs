import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'dart:ui' as ui;

class EdgeWidget extends StatelessWidget {
  const EdgeWidget({super.key, required this.edge});
  final Edge edge;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        height: 60,
        child: CustomPaint(
          painter: EdgePainter(edge),
        ),
      ),
    );
  }
}

class EdgePainter extends CustomPainter {
  final Edge edge;

  EdgePainter(this.edge);

  @override
  void paint(Canvas canvas, Size size) {
    const c1 = Offset(30, 30);
    const c2 = Offset(150, 30);
    const c3 = Offset(90, 30);

    canvas.drawLine(
      c1 + const Offset(10, 0),
      c3 - const Offset(10, 0),
      Paint()
        ..color = edge.component.color
        ..strokeWidth = 2,
    );
    canvas.drawLine(
      c3 + const Offset(10, 0),
      c2 - const Offset(10, 0),
      Paint()
        ..color = edge.component.color
        ..strokeWidth = 2,
    );
    renderText(canvas, c3, edge.weight.toString());

    canvas.drawCircle(
      c1,
      20,
      Paint()..color = edge.from.component.color,
    );
    renderText(canvas, c1, edge.from.label);

    canvas.drawCircle(
      c2,
      20,
      Paint()..color = edge.to.component.color,
    );
    renderText(canvas, c2, edge.to.label);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void renderText(Canvas canvas, Offset offset, String label) {
    const paragraphFontSize = Globals.defaultVertexFontSize;
    const fontSize = paragraphFontSize + 2;
    const fontWeight = FontWeight.normal;
    const fontColor = Globals.defualtVertexFontColor;
    var text = label;

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
        offset.dx - hpainter.width / 2,
        offset.dy - hpainter.height / 2,
      ),
    );
  }
}
