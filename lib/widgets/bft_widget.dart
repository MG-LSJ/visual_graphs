import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/traversal/bft.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/functions/load_traversal_sample_graph.dart';
import 'package:visual_graphs/helpers/functions/pick_starting_vertex.dart';
import 'package:visual_graphs/widgets/components/animate_vertex.dart';
import 'package:visual_graphs/widgets/components/vertex_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';
import 'package:visual_graphs/widgets/components/starting_vertex.dart';
import 'package:visual_graphs/widgets/components/vertex_list_grid.dart';
import 'package:visual_graphs/widgets/components/vertex_queue.dart';
import 'package:visual_graphs/widgets/components/white_border.dart';

class BFTWidget extends StatefulWidget {
  const BFTWidget({super.key});

  @override
  State<BFTWidget> createState() => _BFTWidgetState();
}

class _BFTWidgetState extends State<BFTWidget> {
  late BreadthFirstTraversal bft;
  final Map<int, Widget> vertexWidgets = {};

  @override
  void initState() {
    super.initState();
    bft = BreadthFirstTraversal(graph: Globals.game.graph);
  }

  @override
  Widget build(BuildContext context) {
    vertexWidgets.clear();
    for (var vertex in Globals.game.graph.vertices) {
      vertexWidgets[vertex.id] = VertexWidget(vertex);
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Starting Vertex:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        StartingVertex(vertexWidgets: vertexWidgets),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Visiting:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  WhiteBorder(
                    child: SizedBox(
                      height: 60,
                      child: ValueListenableBuilder(
                        valueListenable: bft.visitingVertexNotifier,
                        builder: (context, Vertex? visitingVertex, child) {
                          return (visitingVertex != null)
                              ? AnimatedMove(
                                  initialOffset: const Offset(100, 0),
                                  duration: const Duration(milliseconds: 120),
                                  child: vertexWidgets[visitingVertex.id]!,
                                )
                              : const EmptyText();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  const Text(
                    "Queue: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  WhiteBorder(
                    // child: VertexQueue(bft.queue, vertexWidgets, 4),
                    child: ListenableBuilder(
                      listenable: bft.queue,
                      builder: (context, child) {
                        return VertexQueue(bft.queueVertices, vertexWidgets, 4);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Seen: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        WhiteBorder(
          child: ListenableBuilder(
            listenable: bft.seen,
            builder: (context, child) {
              return VertexListGrid(bft.seenVertices, vertexWidgets, 6, 2);
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Visited: ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        WhiteBorder(
          child: ListenableBuilder(
            listenable: bft.visited,
            builder: (context, child) {
              return VertexListGrid(bft.visitedVertices, vertexWidgets, 6, 2);
            },
          ),
        ),
        const Spacer(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                if (bft.isRunning) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("BFT is already running"),
                    ),
                  );
                  return;
                }

                if (Globals.game.graph.pickedVertexNotifier.value == null) {
                  pickStartingVertex(context);
                  return;
                }

                Globals.game.gameMode = GameMode.lockedMode;

                Globals.game.resetGraphColors();
                bft.start(Globals.game.graph.pickedVertexNotifier.value!);
              },
              child: const Text("Start BFT"),
            ),
            ElevatedButton(
              onPressed: () {
                Globals.game.resetGraphColors();
                Globals.game.graph.pickedVertexNotifier.value = null;
                bft.clear();
                setState(() {});
              },
              child: const Text("Reset"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const TextButton(
          onPressed: loadTraversalSampleGraph,
          child: Text("Load Sample Graph"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
