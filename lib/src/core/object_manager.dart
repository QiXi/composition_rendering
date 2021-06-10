import 'base_object.dart';
import 'sorted_list.dart';

class ObjectManager<T extends BaseObject> extends BaseObject {
  final SortedList<T> _objectArray;
  final List<T> _pendingAdditions;
  final List<T> _pendingRemovals;

  ObjectManager()
      : _objectArray = SortedList(),
        _pendingAdditions = [],
        _pendingRemovals = [];

  @override
  void reset() {
    commitUpdates();
    _objectArray.forEach((element) => element.reset());
    _objectArray.clear();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    commitUpdates();
    _objectArray.forEach((element) => element.update(deltaTime, this));
  }

  void commitUpdates() {
    if (_pendingAdditions.isNotEmpty) {
      _pendingAdditions.forEach((element) => _objectArray.add(element));
      _pendingAdditions.clear();
    }
    if (_pendingRemovals.isNotEmpty) {
      _pendingRemovals.forEach((element) => _objectArray.remove(element));
      _pendingRemovals.clear();
    }
  }

  int get count {
    return _objectArray.count;
  }

  int get concreteCount {
    return _objectArray.count + _pendingAdditions.length - _pendingRemovals.length;
  }

  T getAt(int index) {
    return _objectArray.list[index];
  }

  SortedList<T> getObjects() => _objectArray;

  List<T> getAdditionsArray() => _pendingAdditions;

  void add(T object) {
    _pendingAdditions.add(object);
  }

  void remove(T object) {
    _pendingRemovals.add(object);
  }

  void removeAll() {
    _pendingAdditions.clear();
    _objectArray.forEach((element) => _pendingRemovals.add(element));
  }

  E? findByType<E extends BaseObject>() {
    var object = _findByType<E>(_objectArray.list);
    object ??= _findByType<E>(_pendingAdditions);
    return object;
  }

  E? _findByType<E extends BaseObject>(List<T> _objectArray) {
    final count = _objectArray.length;
    for (var i = 0; i < count; i++) {
      var currentObject = _objectArray[i];
      if (currentObject.runtimeType == E) {
        return currentObject as E;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'ObjectManager{ count:$count +[${_pendingAdditions.length}] -[${_pendingRemovals.length}] [$hashCode]}';
  }
}
