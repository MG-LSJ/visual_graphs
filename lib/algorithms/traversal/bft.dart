import 'package:visual_graphs/algorithms/traversal/traversal.dart';
import 'package:visual_graphs/graph_editor/models/graph.dart';
import 'package:visual_graphs/helpers/data_structures/pair.dart';
import 'package:visual_graphs/helpers/notifiers/queue_notifier.dart';

class BreadthFirstTraversal extends Traversal {
  final QueueNotifier<Pair<Vertex, Edge?>> queue = QueueNotifier();

  BreadthFirstTraversal({required super.graph});

  @override
  void start(Vertex startVertex) async {
    clear();
    isRunning = true;
    await see(Pair(startVertex, null));
    await Future.delayed(delay);

    while (queue.isNotEmpty) {
      final pair = queue.dequeue();
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
    queue.enqueue(pair);
  }

  @override
  void clear() {
    super.clear();
    queue.clear();
  }

  List<Vertex> get queueVertices {
    return queue.queue.map((pair) => pair.first).toList();
  }
}
