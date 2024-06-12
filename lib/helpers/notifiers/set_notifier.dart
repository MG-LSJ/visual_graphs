import 'package:flutter/material.dart';

class SetNotifier<T> extends ChangeNotifier {
  Set<T> _set = {};

  void add(T value) {
    _set.add(value);
    notifyListeners();
  }

  void remove(T value) {
    _set.remove(value);
    notifyListeners();
  }

  void clear() {
    _set.clear();
    notifyListeners();
  }

  Set<T> get set {
    return Set.from(_set);
  }

  bool contains(T value) {
    return _set.contains(value);
  }

  bool get isEmpty => _set.isEmpty;
  bool get isNotEmpty => _set.isNotEmpty;

  List<T> toList() => _set.toList();

  int get length => _set.length;

  SetNotifier();
  SetNotifier.from(SetNotifier other) : _set = Set.from(other._set);
}
