import 'dirty.dart';
import 'object_manager.dart';
import 'phased_object.dart';

const phasedObjectComparator = _compare;

int _compare(PhasedObject obj1, PhasedObject obj2) {
  return obj1.phase - obj2.phase;
}

class PhasedObjectManager<T extends PhasedObject> extends ObjectManager<T> with Dirty {
  PhasedObjectManager() {
    getObjects().setComparator(phasedObjectComparator);
  }

  @override
  void reset() {
    super.reset();
    dirty = false;
  }

  @override
  void commitUpdates() {
    super.commitUpdates();
    if (dirty) {
      dirty = false;
      getObjects().sort(true);
    }
  }

  @override
  void add(T object) {
    super.add(object);
    dirty = true;
  }

  @override
  String toString() {
    return 'PhasedObjectManager{ dirty:$dirty [$hashCode]}';
  }
}
