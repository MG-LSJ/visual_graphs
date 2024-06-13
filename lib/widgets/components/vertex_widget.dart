import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';

class VertexWidget extends StatelessWidget {
  const VertexWidget(this.vertex, {super.key});
  final Vertex vertex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: vertex.component.radius * 2,
        height: vertex.component.radius * 2,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: vertex.component.color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            vertex.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: Globals.defaultVertexFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
