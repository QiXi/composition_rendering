import 'package:composition_rendering/engine.dart';

import 'game_factory.dart';

class PlayerComponent extends Component with Factory {
  late final SpriteComponent sprite;
  double _currentTime = 0;
  double spawnTime = 0;
  double radians = 0;

  @override
  void reset() {}

  @override
  void spawn(BaseObject parent) {
    if (parent is SceneObject) {
      sprite = parent.findByType<SpriteComponent>()!;
      sprite.rotation = radians;
    }
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    _currentTime += deltaTime;
    if (parent is SceneObject) {
      radians = Lerp.lerpRadians(radians, radians + 0.01, 0, 0);
      sprite.rotation = radians;
      if (_currentTime > spawnTime) {
        spawnTime = _currentTime + 0.5;
        parent.scene!.add(gameFactory.spawnBullet('bullet1.png', radians, 50)
          ..position.setFrom(parent.position)
          ..spawn());
      }
    }
  }
}
