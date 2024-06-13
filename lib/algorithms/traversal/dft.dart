import 'package:visual_graphs/algorithms/traversal/traversal.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/data_structures/pair.dart';
import 'package:visual_graphs/helpers/notifiers/stack_notifier.dart';

class DepthFirstTraversal extends Traversal {
  final StackNotifier<Pair<Vertex, Edge?>> stack = StackNotifier();

  DepthFirstTraversal({required super.graph});

  @override
  void start(Vertex startVertex) async {
    clear();
    isRunning = true;
    await see(Pair(startVertex, null));
    await Future.delayed(delay);

    while (stack.isNotEmpty) {
      final pair = stack.pop();
      await visit(pair);

      var neighbours = pair.first.neighbours;

      for (final neighbour in neighbours.keys) {
        if (!seen.contains(neighbour)) {
          see(Pair(neighbour, neighbours[neighbour]!.first));
        }
      }
      await Future.delayed(delay);
    }
    await end();
  }

  @override
  Future see(Pair<Vertex, Edge?> pair) async {
    await super.see(pair);
    stack.push(pair);
  }

  @override
  void clear() {
    super.clear();
    stack.clear();
  }

  List<Vertex> get stackVerticies {
    return stack.stack.map((pair) => pair.first).toList();
  }
}
