import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class VertexList extends StatelessWidget {
  const VertexList(this.vertices, this.vertexWidgets, {super.key});
  final Iterable<Vertex> vertices;
  final Map<int, Widget> vertexWidgets;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemExtent: 60,
      children: vertices.isNotEmpty
          ? [for (final vertex in vertices) vertexWidgets[vertex.id]!]
          : [const EmptyText()],
    );
  }
}
