import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/mst/kruskals_algorithm.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/helpers/functions/load_mst_sample_graph.dart';
import 'package:visual_graphs/widgets/components/animate_move.dart';
import 'package:visual_graphs/widgets/components/edge_grid.dart';
import 'package:visual_graphs/widgets/components/edge_queue.dart';
import 'package:visual_graphs/widgets/components/edge_widget.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';
import 'package:visual_graphs/widgets/components/white_border.dart';

class KruskalWidget extends StatefulWidget {
  const KruskalWidget({super.key});

  @override
  State<KruskalWidget> createState() => _KruskalWidgetState();
}

class _KruskalWidgetState extends State<KruskalWidget> {
  KruskalsAlgorithm kruskal = KruskalsAlgorithm();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            listenable: kruskal.includedEdges,
            builder: (context, child) {
              return EdgeAnimatedGrid(kruskal.includedEdges.set, 2, 4, true);
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      valueListenable: kruskal.currentEdge,
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
                      valueListenable: kruskal.weightNotifier,
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
          "Sorted Edges Queue:",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        WhiteBorder(
          child: ValueListenableBuilder(
            valueListenable: kruskal.currentEdge,
            builder: (context, value, child) {
              return EdgeQueue(
                kruskal.edges.sublist(kruskal.index),
                2,
                4,
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
                if (kruskal.isRunning) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("kruskal's Algorithm is already running"),
                    ),
                  );
                  return;
                }
                kruskal.start();
              },
              child: const Text("Start Kruskal"),
            ),
            ElevatedButton(
              onPressed: () {
                Globals.game.resetGraphColors();
                kruskal.clear();
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
