import '../../scene.dart';
import '../../systems.dart';

abstract class Scene extends BaseObject with Registry {
  final SceneObjectManager _sceneManager = SceneObjectManager();

  void init();

  void updateScene(double deltaTime) {
    systems.debugSystem.startUpdate();
    _sceneManager.update(deltaTime, this);
    systems.debugSystem.stopUpdate();
  }

  @override
  void reset() {
    _sceneManager.reset();
  }

  void add(SceneObject object) {
    _sceneManager.add(object);
    object.scene = this;
  }

  void remove(SceneObject object) {
    _sceneManager.remove(object);
  }

  void removeAll() {
    _sceneManager.destroyAll();
  }
}
