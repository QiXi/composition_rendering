import '../../core.dart';
import 'scene_object.dart';

class SceneObjectManager extends ObjectManager<SceneObject> {
  final List<SceneObject> _markedForDeath;

  SceneObjectManager() : _markedForDeath = [];

  @override
  void commitUpdates() {
    super.commitUpdates();
    _markedForDeath.clear();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    commitUpdates();
    getObjects().forEach((element) {
      if (element.destroyOnDeactivation) {
        destroy(element);
      } else {
        element.update(deltaTime, this);
      }
    });
  }

  void destroy(SceneObject object) {
    _markedForDeath.add(object);
    remove(object);
  }

  void destroyAll() {
    commitUpdates();
    var objects = getObjects();
    objects.forEach((element) {
      _markedForDeath.add(element);
      remove(element);
    });
  }

  Iterable<SceneObject> getDeathObjects() => _markedForDeath;
}
