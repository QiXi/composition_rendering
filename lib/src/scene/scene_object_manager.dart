import '../../core.dart';
import 'scene_object.dart';

class SceneObjectManager extends ObjectManager<SceneObject> {
  final List<SceneObject> _markedForDeath = [];

  SceneObjectManager();

  @override
  void commitUpdates() {
    super.commitUpdates();
    _markedForDeath.clear();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    commitUpdates();
    var objects = getObjects().data;
    for (int i = 0; i < objects.length; i++) {
      var object = objects[i];
      if (object.destroyOnDeactivation) {
        destroy(object);
      } else {
        object.update(deltaTime, this);
      }
    }
  }

  void destroy(SceneObject object) {
    _markedForDeath.add(object);
    remove(object);
    object.reset();
  }

  void destroyAll() {
    commitUpdates();
    getObjects().forEach(destroy);
  }

  Iterable<SceneObject> getDeathObjects() => _markedForDeath;
}
