class SortedList<T> {
  final List<T> data;
  bool _sorted;
  int Function(T a, T b)? _comparator;

  SortedList({int Function(T a, T b)? comparator})
      : data = [],
        _sorted = false,
        _comparator = comparator;

  void setComparator(int Function(T a, T b)? comparator) {
    _comparator = comparator;
    _sorted = false;
  }

  int get count => data.length;

  int getCapacity() => data.length;

  void add(T object) {
    data.add(object);
    _sorted = false;
  }

  void remove(T object) {
    data.remove(object);
    _sorted = false;
  }

  void clear() {
    data.clear();
    _sorted = false;
  }

  void forEach(void Function(T element) action) {
    data.forEach(action);
  }

  void sort(bool forceResort) {
    //TODO performance
    if (!_sorted || forceResort) {
      if (_comparator != null) {
        data.sort(_comparator);
      } else {
        data.sort();
      }
      _sorted = true;
    }
  }
}
