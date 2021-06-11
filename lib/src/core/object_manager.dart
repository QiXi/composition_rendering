import 'base_object.dart';
import 'sorted_list.dart';

class ObjectManager<T extends BaseObject> extends BaseObject {
  final SortedList<T> _objectList;
  final List<T> _pendingAdditions;
  final List<T> _pendingRemovals;

  ObjectManager()
      : _objectList = SortedList(),
        _pendingAdditions = [],
        _pendingRemovals = [];

  @override
  void reset() {
    commitUpdates();
    _objectList.list.forEach((element) => element.reset());
    _objectList.clear();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    commitUpdates();
    _objectList.list.forEach((element) => element.update(deltaTime, this));
  }

  void commitUpdates() {
    if (_pendingAdditions.isNotEmpty) {
      _objectList.list.addAll(_pendingAdditions);
      _pendingAdditions.clear();
    }
    if (_pendingRemovals.isNotEmpty) {
      _pendingRemovals.forEach((element) => _objectList.remove(element));
      _pendingRemovals.clear();
    }
  }

  int get count {
    return _objectList.count;
  }

  int get concreteCount {
    return _objectList.count + _pendingAdditions.length - _pendingRemovals.length;
  }

  T getAt(int index) {
    return _objectList.list[index];
  }

  SortedList<T> getObjects() => _objectList;

  List<T> getAdditionsArray() => _pendingAdditions;

  void add(T object) {
    _pendingAdditions.add(object);
  }

  void remove(T object) {
    _pendingRemovals.add(object);
  }

  void removeAll() {
    _pendingAdditions.clear();
    _objectList.list.forEach((element) => _pendingRemovals.add(element));
  }

  E? findByType<E extends BaseObject>() {
    var object = _findByType<E>(_objectList.list);
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
