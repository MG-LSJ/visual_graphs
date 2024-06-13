import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class VertexQueue extends StatefulWidget {
  const VertexQueue(
      this.vertices, this.vertexWidgets, this.colCount, this.rowCount,
      {super.key});
  final int colCount;
  final int rowCount;
  final List<Vertex> vertices;
  final Map<int, Widget> vertexWidgets;

  @override
  State<VertexQueue> createState() => _VertexQueueState();
}

class _VertexQueueState extends State<VertexQueue> {
  List<Vertex> previousVertices = [];
  final double rowHeight = 60;

  @override
  Widget build(BuildContext context) {
    int i = 0;
    var wid = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: rowHeight * widget.rowCount,
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.rowCount,
          childAspectRatio: 1,
          mainAxisExtent: 60,
        ),
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
                      initialOffset: const Offset(50, 0),
                      duration: const Duration(milliseconds: 120),
                      child: widget.vertexWidgets[widget.vertices[i].id]!),
              ]
            : [const EmptyText()],
      ),
    );

    previousVertices = List.from(widget.vertices);
    return wid;
  }
}
