import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';
import 'package:visual_graphs/widgets/components/vertex_widget.dart';

class VertexAnimatedGrid extends StatefulWidget {
  const VertexAnimatedGrid(
      this.vertices, this.vertexWidgets, this.colCount, this.rowCount,
      {super.key});

  final int colCount;
  final int rowCount;
  final Iterable<Vertex> vertices;
  final Map<int, Widget> vertexWidgets;

  @override
  State<VertexAnimatedGrid> createState() => _VertexAnimatedGridState();
}

class _VertexAnimatedGridState extends State<VertexAnimatedGrid> {
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
        children: getVertexWidgets(),
      ),
    );
  }

  List<Widget> getVertexWidgets() {
    if (widget.vertices.isEmpty) return [const EmptyText()];
    List<Widget> children = [];

    for (final vertex in widget.vertices) {
      children.add(widget.vertexWidgets[vertex.id] ?? Container());
    }

    int last = widget.vertices.length - 1;
    children[last] = AnimatedMove(
      initialOffset: getOffset(last),
      duration: const Duration(milliseconds: 200),
      child: VertexWidget(widget.vertices.last),
    );
    return children;
  }

  Offset getOffset(int last) {
    last %= widget.colCount;

    switch (last) {
      case 0:
        return const Offset(20, 100);
      case 1:
        return const Offset(-20, 100);
      case 2:
        return const Offset(-80, 100);
      case 3:
        return const Offset(-140, 100);
      case 4:
        return const Offset(-200, 100);
      case 5:
        return const Offset(-260, 100);
      default:
        return const Offset(-320, 100);
    }
  }
}
