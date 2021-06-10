class SortedList<T> {
  final List<T> _data;
  bool _sorted;
  int Function(T a, T b)? _comparator;

  SortedList({int Function(T a, T b)? comparator})
      : _data = [],
        _sorted = false,
        _comparator = comparator;

  void setComparator(int Function(T a, T b)? comparator) {
    _comparator = comparator;
    _sorted = false;
  }

  int get count => _data.length;

  int getCapacity() => _data.length;

  List<T> get list => _data;

  void add(T object) {
    _data.add(object);
    _sorted = false;
  }

  void remove(T object) {
    _data.remove(object);
    _sorted = false;
  }

  void clear() {
    _data.clear();
    _sorted = false;
  }

  void forEach(void Function(T element) action) {
    _data.forEach(action);
  }

  void sort(bool forceResort) {
    if (!_sorted || forceResort) {
      if (_comparator != null) {
        _data.sort(_comparator);
      } else {
        _data.sort();
      }
      _sorted = true;
    }
  }
}
