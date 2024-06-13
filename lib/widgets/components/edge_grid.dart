import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/edge_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class EdgeGrid extends StatefulWidget {
  const EdgeGrid(this.edges, this.colCount, this.rowCount, this.scrollToLast,
      {super.key});

  final bool scrollToLast;
  final int colCount;
  final int rowCount;
  final Iterable<Edge> edges;

  @override
  State<EdgeGrid> createState() => _EdgeGridState();
}

class _EdgeGridState extends State<EdgeGrid> {
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
      if (widget.scrollToLast && _scrollController.hasClients) {
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
        children: widget.edges.isNotEmpty
            ? [
                for (final edge in widget.edges) EdgeWidget(edge: edge),
              ]
            : [const EmptyText()],
      ),
    );
  }
}
