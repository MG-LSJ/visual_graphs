class QueueDS<T> {
  final List<T> _queue = [];

  void enqueue(T item) {
    _queue.add(item);
  }

  T dequeue() {
    return _queue.removeAt(0);
  }

  T peek() {
    return _queue.first;
  }

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;

  void clear() {
    _queue.clear();
  }

  List<T> get queue => List.from(_queue);
}
