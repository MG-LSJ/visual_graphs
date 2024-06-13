import 'package:flutter/material.dart';
import 'dart:collection';

class QueueNotifier<T> with ChangeNotifier {
  final Queue<T> _queue = Queue();

  void enqueue(T value) {
    _queue.addLast(value);
    notifyListeners();
  }

  T dequeue() {
    final value = _queue.removeFirst();
    notifyListeners();
    return value;
  }

  void clear() {
    _queue.clear();
    notifyListeners();
  }

  List<T> get queue => _queue.toList();

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
}
