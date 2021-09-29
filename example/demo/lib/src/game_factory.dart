import 'package:composition_rendering/engine.dart';

import 'components/bullet_component.dart';
import 'player_component.dart';

// Factory
class GameFactory with Registry {
  // Regular sprite that can be rotated, scaled or set transparency
  SceneObject spawnBackground() {
    var texture = textures.getTextureRegion('bg.jpg');
    return factory.spawnSprite(texture!, Priority.background, scale: 0.75);
  }

  // BulletComponent moves in a given direction and is destroyed out of sight
  SceneObject spawnBullet(String fileName, double rotation, double offsetY) {
    var texture = textures.getTextureRegion(fileName);
    return factory.spawnSprite(texture!, Priority.foregroundObjectEffect,
        scale: 0.5)
      ..add(BulletComponent(
          rotation: rotation,
          startOffset:
              offsetY)); //for an example of dynamically binding a BulletComponent to a sprite
  }

  // Player object consists of a sprite and a name
  SceneObject spawnPlayer(String fileName, double rotation) {
    var texture = textures.getTextureRegion(fileName);
    // Name
    var nameRender = RenderComponent(Priority.overlay);
    nameRender.setDrawOffset(-20, -60);
    var nameComponent = TextComponent(
      '[Player]',
      nameRender,
    );
    return factory.spawnSprite(texture!, Priority.player,
        scale: 0.5, rotation: rotation)
      ..add(nameRender)
      ..add(nameComponent)
      ..add(PlayerComponent())
      ..spawn();
  }

  FactorySystem get factory => systems.factorySystem;

  TextureSystem get textures => systems.textureSystem;
}

mixin Factory {
  static final GameFactory _gameFactory = GameFactory();

  GameFactory get gameFactory => _gameFactory;
}
