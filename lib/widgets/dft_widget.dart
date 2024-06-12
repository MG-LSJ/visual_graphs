import 'package:flutter/material.dart';
import 'package:visual_graphs/algorithms/dft.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/helpers/functions/pick_starting_vertex.dart';
import 'package:visual_graphs/widgets/components/animate_vertex.dart';
import 'package:visual_graphs/widgets/components/circle_vertex.dart';
import 'package:visual_graphs/widgets/components/empty_text.dart';
import 'package:visual_graphs/widgets/components/starting_vertex.dart';
import 'package:visual_graphs/widgets/components/vertex_list_grid.dart';
import 'package:visual_graphs/widgets/components/vertex_stack.dart';
import 'package:visual_graphs/widgets/components/white_border.dart';

class DFTWidget extends StatefulWidget {
  const DFTWidget({super.key});

  @override
  State<DFTWidget> createState() => _DFTWidgetState();
}

class _DFTWidgetState extends State<DFTWidget> {
  late DepthFirstTraversal dft;
  final Map<int, Widget> vertexWidgets = {};

  @override
  void initState() {
    super.initState();
    dft = DepthFirstTraversal(graph: Globals.game.graph);
  }

  @override
  Widget build(BuildContext context) {
    vertexWidgets.clear();
    for (var vertex in Globals.game.graph.vertices) {
      vertexWidgets[vertex.id] = CircleVertex(vertex);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const SizedBox(height: 10),
        StartingVertex(vertexWidgets: vertexWidgets),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
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
                          valueListenable: dft.visitingVertexNotifier,
                          builder: (context, Vertex? visitingVertex, child) {
                            return (visitingVertex != null)
                                ? AnimatedMove(
                                    initialOffset: const Offset(0, 100),
                                    duration: const Duration(milliseconds: 120),
                                    child: vertexWidgets[visitingVertex.id]!,
                                  )
                                : const EmptyText();
                          }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Stack: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  WhiteBorder(
                    child: ListenableBuilder(
                      listenable: dft.stack,
                      builder: (context, child) {
                        return VertexStack(
                          dft.stackVerticies.reversed.toList(),
                          vertexWidgets,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      listenable: dft.seen,
                      builder: (context, child) {
                        return VertexListGrid(
                            dft.seenVertices, vertexWidgets, 4, 3);
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
                      listenable: dft.visited,
                      builder: (context, child) {
                        return VertexListGrid(
                            dft.visitedVertices, vertexWidgets, 4, 3);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () {
            if (dft.isRunning) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("DFT is already running"),
                ),
              );
              return;
            }

            if (Globals.game.graph.pickedVertexNotifier.value == null) {
              pickStartingVertex(context);
              return;
            }

            Globals.game.editorWidgetState.setState(() {
              Globals.game.gameMode = GameMode.lockedMode;
            });
            Globals.game.resetGraphColors();
            dft.start(Globals.game.graph.pickedVertexNotifier.value!);
          },
          child: const Text("Start DFT"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Globals.game.resetGraphColors();
            Globals.game.graph.pickedVertexNotifier.value = null;
            dft.clear();
          },
          child: const Text("Reset"),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
