import 'dart:math' as math;
import 'dart:ui';
import 'package:visual_graphs/components/graph_game.dart';
import 'package:visual_graphs/components/vertex_component.dart';
import 'package:flame/components.dart';

class HalfEdgeComponent extends ShapeComponent with HasGameRef<GraphGame> {
  VertexComponent v;
  Color color = const Color(0xFFFFFFFF);

  HalfEdgeComponent(this.v) {
    anchor = Anchor.center;
    position = v.position;
    paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = v.position;
  }

  @override
  void render(Canvas canvas) {
    var cursorPosition = gameRef.camera.globalToLocal(gameRef.cursorPosition);

    var endPoint = Offset(
      cursorPosition.x - v.position.x,
      cursorPosition.y - v.position.y,
    );

    var angle = endPoint.direction;

    var adjustedStartPoint =
        Offset(math.cos(angle) * v.radius, math.sin(angle) * v.radius);

    if (endPoint.distance < v.radius) {
      return;
    }
    var path = Path()
      ..moveTo(adjustedStartPoint.dx, adjustedStartPoint.dy)
      ..lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }
}
