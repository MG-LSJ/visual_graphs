import 'package:flutter/material.dart';
import 'package:visual_graphs/helpers/data_structures/stack.dart';

class StackNotifier<T> extends ChangeNotifier {
  final StackDS<T> _stack = StackDS();

  void push(T item) {
    _stack.push(item);
    notifyListeners();
  }

  T pop() {
    final item = _stack.pop();
    notifyListeners();
    return item;
  }

  T peek() {
    return _stack.peek();
  }

  bool get isEmpty => _stack.isEmpty;
  bool get isNotEmpty => _stack.isNotEmpty;

  void clear() {
    _stack.clear();
    notifyListeners();
  }

  List<T> get stack => _stack.stack;
}
