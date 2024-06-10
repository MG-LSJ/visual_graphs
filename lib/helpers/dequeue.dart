class Dequeue<T> {
  final List<T> _dequeue = [];

  void addFirst(T item) {
    _dequeue.insert(0, item);
  }

  void addLast(T item) {
    _dequeue.add(item);
  }

  T removeFirst() {
    return _dequeue.removeAt(0);
  }

  T removeLast() {
    return _dequeue.removeLast();
  }

  T peekFirst() {
    return _dequeue.first;
  }

  T peekLast() {
    return _dequeue.last;
  }

  bool get isEmpty => _dequeue.isEmpty;
  bool get isNotEmpty => _dequeue.isNotEmpty;

  void clear() {
    _dequeue.clear();
  }
}
