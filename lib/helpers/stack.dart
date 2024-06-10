class StackDS<T> {
  final List<T> _stack = [];

  void push(T item) {
    _stack.add(item);
  }

  T pop() {
    return _stack.removeLast();
  }

  T peek() {
    return _stack.last;
  }

  bool get isEmpty => _stack.isEmpty;
  bool get isNotEmpty => _stack.isNotEmpty;

  void clear() {
    _stack.clear();
  }
}

class SizedStackDS<T> extends StackDS<T> {
  final int _maxSize;
  SizedStackDS(this._maxSize);

  @override
  void push(T item) {
    if (_stack.length >= _maxSize) {
      _stack.removeAt(0);
    }
    super.push(item);
  }
}
