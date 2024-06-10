import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/bft.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';

class BFTWidget extends StatefulWidget {
  const BFTWidget({super.key});

  @override
  State<BFTWidget> createState() => _BFTWidgetState();
}

class _BFTWidgetState extends State<BFTWidget> {
  late BreadthFirstTraversal bft;
  Vertex? startVertex;

  @override
  void initState() {
    super.initState();
    bft = BreadthFirstTraversal(graph: Globals.game.graph, state: this);
  }

  @override
  Widget build(BuildContext context) {
    startVertex = Globals.game.graph.vertices.first;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Breadth First Traversal",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // SizedBox(
        //   height: 100,
        //   child:
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 50,
          ),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            const Center(
              child: Text(
                "Starting Vertex:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Currently Visiting: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            (startVertex != null) ? CircleVertex(startVertex!) : _emptyText(),
            (bft.visiting != null) ? CircleVertex(bft.visiting!) : _emptyText(),
          ],
        ),
        // ),
        const SizedBox(height: 20),
        const Text(
          "Queue: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        _nodeListBuilder(bft.queue),
        const SizedBox(height: 20),
        const Text(
          "Seen: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        _nodeListBuilder(bft.seen),
        const SizedBox(height: 20),
        const Text(
          "Visited: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        _nodeListBuilder(bft.visited),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              startVertex = Globals.game.graph.vertices.first;
            });
            if (startVertex == null || bft.isRunning) return;
            Globals.game.editorWidgetState.setState(() {
              Globals.game.gameMode = GameMode.lockedMode;
            });
            Globals.game.resetGraphColors();
            bft.start(startVertex!);
          },
          child: const Text("Start BFT"),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {
            Globals.game.resetGraphColors();
            bft.clear();
          },
          child: const Text("Reset"),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _nodeListBuilder(Iterable<Vertex> list) => GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1,
        ),
        physics: const ScrollPhysics(),
        children: list.isNotEmpty
            ? [for (final vertex in list) CircleVertex(vertex)]
            : [_emptyText()],
      );

  Widget _emptyText() =>
      const Center(child: Text("Empty", style: TextStyle(color: Colors.grey)));
}

class CircleVertex extends StatelessWidget {
  const CircleVertex(this.vertex, {super.key});

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
