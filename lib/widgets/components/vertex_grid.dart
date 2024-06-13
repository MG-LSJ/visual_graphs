import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class VertexGrid extends StatefulWidget {
  const VertexGrid(
      this.vertices, this.vertexWidgets, this.colCount, this.rowCount,
      {super.key});

  final int colCount;
  final int rowCount;
  final Iterable<Vertex> vertices;
  final Map<int, Widget> vertexWidgets;

  @override
  State<VertexGrid> createState() => _VertexGridState();
}

class _VertexGridState extends State<VertexGrid> {
  final double rowHeight = 60;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: rowHeight * widget.rowCount,
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.colCount,
          childAspectRatio: 1,
          mainAxisExtent: rowHeight,
        ),
        children: widget.vertices.isNotEmpty
            ? [
                for (final vertex in widget.vertices)
                  (widget.vertexWidgets[vertex.id] ?? Container())
              ]
            : [const EmptyText()],
      ),
    );
  }
}
