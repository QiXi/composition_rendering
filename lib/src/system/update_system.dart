import 'registry.dart';

class UpdateSystem with Registry {
  void update(double deltaTime) {
    systems.cameraSystem.update(deltaTime);
    systems.debugSystem.update(deltaTime);
  }
}
