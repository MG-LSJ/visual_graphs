import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class VertexStack extends StatefulWidget {
  const VertexStack(this.vertices, this.vertexWidgets, {super.key});

  final List<Vertex> vertices;
  final Map<int, Widget> vertexWidgets;
  @override
  State<VertexStack> createState() => _VertexStackState();
}

class _VertexStackState extends State<VertexStack> {
  List<Vertex> previousVertices = [];

  @override
  Widget build(BuildContext context) {
    int i = 0;
    var wid = ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemExtent: 60,
      children: widget.vertices.isNotEmpty
          ? [
              for (;
                  i < widget.vertices.length &&
                      i < previousVertices.length &&
                      widget.vertices[i] == previousVertices[i];
                  i++)
                widget.vertexWidgets[widget.vertices[i].id]!,
              for (; i < widget.vertices.length; i++)
                AnimatedMove(
                    initialOffset: const Offset(0, 50),
                    duration: const Duration(milliseconds: 120),
                    child: widget.vertexWidgets[widget.vertices[i].id]!),
            ]
          : [const EmptyText()],
    );

    previousVertices = List.from(widget.vertices);
    return wid;
  }
}
