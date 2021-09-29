import 'package:composition_rendering/components.dart';
import 'package:composition_rendering/core.dart';

class BulletComponent extends Component {
  final Vector2 _positionWorkspace;
  SpriteComponent? _sprite;
  double _currentTime = 0;
  double _lifeTime = 3;
  double rotation;
  double speed;
  double startOffset;

  BulletComponent(
      {required this.rotation, this.speed = 500, this.startOffset = 0})
      : _positionWorkspace = Vector2.zero() {
    setPhase(ComponentPhases.think);
  }

  @override
  void reset() {}

  @override
  void spawn(BaseObject parent) {
    if (parent is SceneObject) {
      // find a sprite to set the direction of flight
      _sprite = parent.findByType<SpriteComponent>();
      if (_sprite == null) {
        parent.destroy();
      } else {
        _sprite!.rotation = rotation;
        // initial shift of the bullet from the player
        parent.position.x += startOffset * cos(rotation - pi / 2.5);
        parent.position.y += startOffset * sin(rotation - pi / 2.5);
      }
    }
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    _currentTime += deltaTime;
    if (parent is SceneObject) {
      // remove the bullet from the scene the next time the scene is updated
      if (_currentTime > _lifeTime) {
        parent.destroy();
      }
      _positionWorkspace.setFrom(parent.position);
      _positionWorkspace.x += speed * cos(rotation - pi / 2.5) * deltaTime;
      _positionWorkspace.y += speed * sin(rotation - pi / 2.5) * deltaTime;
      parent.position.setFrom(_positionWorkspace);
      // if the bullet did not go beyond the screen, then we extend the life by 1 second
      if (systems.cameraSystem.visibleAtPosition(_positionWorkspace)) {
        _lifeTime = _currentTime + 1;
      }
    }
  }

  @override
  String toString() {
    return 'BulletComponent{ rotation:$rotation speed:$speed [$hashCode]}';
  }
}
