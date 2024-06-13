import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/functions/pick_starting_vertex.dart';
import 'package:visual_graphs/widgets/components/vertex_widget.dart';

class StartingVertex extends StatelessWidget {
  const StartingVertex({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Tooltip(
        message: "Pick a starting vertex",
        child: InkWell(
          onTap: () => pickStartingVertex(context),
          child: ValueListenableBuilder<Vertex?>(
            valueListenable: Globals.game.graph.pickedVertexNotifier,
            builder: (context, vertex, child) {
              return (vertex != null)
                  ? VertexWidget(vertex)
                  : Center(
                      child: Text(
                        "Click to pick",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
