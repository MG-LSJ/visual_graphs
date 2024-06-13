import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PriorityQueueNotifier<T> extends ChangeNotifier {
  final PriorityQueue<T> _pq;

  PriorityQueueNotifier(int Function(T, T) compare)
      : _pq = PriorityQueue<T>(compare);

  T removeFirst() {
    final value = _pq.removeFirst();
    notifyListeners();
    return value;
  }

  void add(T value) {
    _pq.add(value);
    notifyListeners();
  }

  void clear() {
    _pq.clear();
    notifyListeners();
  }

  bool get isEmpty => _pq.isEmpty;
  bool get isNotEmpty => _pq.isNotEmpty;

  List<T> get values => _pq.toList();
}
