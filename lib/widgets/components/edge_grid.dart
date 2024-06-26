import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/edge_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';

class EdgeAnimatedGrid extends StatefulWidget {
  const EdgeAnimatedGrid(
      this.edges, this.colCount, this.rowCount, this.scrollToLast,
      {super.key});

  final bool scrollToLast;
  final int colCount;
  final int rowCount;
  final Iterable<Edge> edges;

  @override
  State<EdgeAnimatedGrid> createState() => _EdgeAnimatedGridState();
}

class _EdgeAnimatedGridState extends State<EdgeAnimatedGrid> {
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
    for (final edge in widget.edges) {
      children.add(EdgeWidget(edge: edge));
    }
    int last = children.length - 1;
    children[last] = AnimatedMove(
      initialOffset:
          last.isEven ? const Offset(0, 100) : const Offset(-150, 100),
      duration: const Duration(milliseconds: 200),
      child: EdgeWidget(edge: widget.edges.last),
    );
    return children;
  }
}
