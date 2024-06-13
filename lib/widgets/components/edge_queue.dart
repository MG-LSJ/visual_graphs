import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/edge_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class EdgeQueue extends StatefulWidget {
  const EdgeQueue(this.edges, this.colCount, this.rowCount, this.scrollToLast,
      {super.key});

  final bool scrollToLast;
  final int colCount;
  final int rowCount;
  final Iterable<Edge> edges;

  @override
  State<EdgeQueue> createState() => _EdgeQueueState();
}

class _EdgeQueueState extends State<EdgeQueue> {
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
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    if (widget.edges.isEmpty) return [const EmptyText()];

    List<Widget> children = [];

    int i = 0;
    for (final edge in widget.edges) {
      children.add(
        AnimatedMove(
          initialOffset:
              i.isEven ? const Offset(150, 0) : const Offset(-150, 100),
          duration: Duration(milliseconds: 200 + i * 50),
          // ?
          // : Duration(milliseconds: 300 + i * 10),
          scale: false,
          child: EdgeWidget(edge: edge),
        ),
      );
      i++;
    }

    return children;
  }
}
