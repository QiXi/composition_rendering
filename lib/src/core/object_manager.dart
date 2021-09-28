import 'base_object.dart';
import 'sorted_list.dart';

class ObjectManager<T extends BaseObject> extends BaseObject {
  final SortedList<T> _objectList = SortedList();
  final List<T> _pendingAdditions = [];
  final List<T> _pendingRemovals = [];

  ObjectManager();

  @override
  void reset() {
    commitUpdates();
    final list = _objectList.data;
    for (var i = 0; i < list.length; i++) {
      list[i].reset();
    }
    _objectList.clear();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    commitUpdates();
    final list = _objectList.data;
    for (var i = 0; i < list.length; i++) {
      list[i].update(deltaTime, this);
    }
  }

  void commitUpdates() {
    if (_pendingAdditions.isNotEmpty) {
      _objectList.data.addAll(_pendingAdditions);
      _pendingAdditions.clear();
    }
    if (_pendingRemovals.isNotEmpty) {
      for (var i = 0; i < _pendingRemovals.length; i++) {
        _objectList.remove(_pendingRemovals[i]);
      }
      _pendingRemovals.clear();
    }
  }

  int get count => _objectList.count;

  int get concreteCount {
    return _objectList.count + _pendingAdditions.length - _pendingRemovals.length;
  }

  T getAt(int index) {
    return _objectList.data[index];
  }

  SortedList<T> getObjects() => _objectList;

  List<T> getAdditionsArray() => _pendingAdditions;

  List<T> getRemovalsArray() => _pendingRemovals;

  void add(T object) {
    _pendingAdditions.add(object);
  }

  void remove(T object) {
    _pendingRemovals.add(object);
  }

  void removeAll() {
    _pendingAdditions.clear();
    final list = _objectList.data;
    for (var i = 0; i < list.length; i++) {
      _pendingRemovals.add(list[i]);
    }
  }

  E? findByType<E extends BaseObject>() {
    var object = _findByType<E>(_objectList.data);
    object ??= _findByType<E>(_pendingAdditions);
    return object;
  }

  E? _findByType<E extends BaseObject>(List<T> _objectArray) {
    final length = _objectArray.length;
    for (var i = 0; i < length; i++) {
      var currentObject = _objectArray[i];
      if (currentObject.runtimeType == E) {
        return currentObject as E;
      }
    }
  }

  @override
  String toString() {
    return 'ObjectManager{ count:$count +[${_pendingAdditions.length}] -[${_pendingRemovals.length}] [$hashCode]}';
  }
}
