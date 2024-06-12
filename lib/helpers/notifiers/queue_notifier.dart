import 'package:flutter/material.dart';
import 'package:visual_graphs/helpers/data_structures/queue.dart';

class QueueNotifier<T> with ChangeNotifier {
  final QueueDS<T> _queue = QueueDS();

  void enqueue(T value) {
    _queue.enqueue(value);
    notifyListeners();
  }

  T dequeue() {
    final value = _queue.dequeue();
    notifyListeners();
    return value;
  }

  void clear() {
    _queue.clear();
    notifyListeners();
  }

  List<T> get queue => _queue.queue;

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
}
