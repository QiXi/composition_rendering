import 'dart:collection';

abstract class ObjectPool<E> {
  final Queue<E> _data = Queue<E>();
  final int size;
  final Function builder;

  ObjectPool(this.builder, [this.size = 32]) {
    fill(_data);
  }

  void reset() {}

  E? allocate() {
    if (_data.isNotEmpty) {
      return _data.removeFirst();
    }
  }

  void release(E entry) => _data.add(entry);

  int get allocatedCount => size - _data.length;

  void fill(Queue<E> data) {
    for (var i = 0; i < size; i++) {
      release(builder());
    }
  }
}
