import 'package:flutter/material.dart';
import 'package:visual_graphs/graph_editor/globals.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/functions/pick_starting_vertex.dart';

class StartingVertex extends StatelessWidget {
  const StartingVertex({super.key, required this.vertexWidgets});
  final Map<int, Widget> vertexWidgets;

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
                  ? vertexWidgets[vertex.id]!
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
