import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/mst/lazy_prims_algorithm.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/helpers/functions/load_mst_sample_graph.dart';
import 'package:visual_graphs/helpers/functions/pick_starting_vertex.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/edge_grid.dart';
import 'package:visual_graphs/widgets/components/edge_queue.dart';
import 'package:visual_graphs/widgets/components/edge_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';
import 'package:visual_graphs/widgets/components/starting_vertex.dart';
import 'package:visual_graphs/widgets/components/white_border.dart';

class PrimsWidget extends StatefulWidget {
  const PrimsWidget({super.key});

  @override
  State<PrimsWidget> createState() => _PrimsWidgetState();
}

class _PrimsWidgetState extends State<PrimsWidget> {
  LazyPrimsAlgorithm prims = LazyPrimsAlgorithm();

  @override
  Widget build(BuildContext context) {
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
        const StartingVertex(),
        const SizedBox(height: 20),
        const Text(
          "Included Edges:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        WhiteBorder(
          child: ListenableBuilder(
            listenable: prims.includedEdges,
            builder: (context, child) {
              return EdgeAnimatedGrid(prims.includedEdges.set, 2, 3, true);
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Current Edge:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                WhiteBorder(
                  child: SizedBox(
                    width: 180,
                    height: 60,
                    child: ValueListenableBuilder(
                      valueListenable: prims.currentEdge,
                      builder: (context, value, child) {
                        if (value == null) return const EmptyText();
                        return AnimatedMove(
                          initialOffset: const Offset(0, 150),
                          duration: const Duration(milliseconds: 200),
                          scale: false,
                          child: EdgeWidget(edge: value),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Weight:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                WhiteBorder(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: ValueListenableBuilder(
                      valueListenable: prims.weightNotifier,
                      builder: (context, weight, child) {
                        return Center(
                          child: Text(
                            weight.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Priority queue:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        WhiteBorder(
          child: ListenableBuilder(
            listenable: prims.pq,
            builder: (context, child) {
              return EdgeQueue(
                prims.pq.values,
                2,
                3,
                false,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                if (prims.isRunning) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Prim's Algorithm is already running"),
                    ),
                  );
                  return;
                }

                if (Globals.game.graph.pickedVertexNotifier.value == null) {
                  pickStartingVertex(context);
                  return;
                }

                prims.start(Globals.game.graph.pickedVertexNotifier.value!);
              },
              child: const Text("Start Prim's"),
            ),
            ElevatedButton(
              onPressed: () {
                Globals.game.resetGraphColors();
                prims.clear();
              },
              child: const Text("Reset"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const TextButton(
          onPressed: loadMSTSampleGraph,
          child: Text("Load Sample Graph"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
