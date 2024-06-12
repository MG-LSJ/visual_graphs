import 'package:flutter/material.dart';

class ListNotifier<T> extends ChangeNotifier {
  final List<T> _list = [];

  List<T> get list => _list;

  void add(T value) {
    _list.add(value);
    notifyListeners();
  }

  void remove(String value) {
    _list.remove(value);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  operator [](int index) => _list[index];

  operator []=(int index, T value) {
    _list[index] = value;
    notifyListeners();
  }

  int get length => _list.length;
}
