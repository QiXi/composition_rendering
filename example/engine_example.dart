import 'package:composition_rendering/core.dart';
import 'package:composition_rendering/scene.dart';

void main() {
  // Creating an action scene in your game
  final gameScene = GameScene();
}

class GameScene extends Scene {
  @override
  void init() {
    // get drawing area from picture
    var texture = systems.textureSystem.getTextureRegion('bg.jpg');
    // create a scene object as a sprite
    var background = systems.factorySystem.spawnSprite(texture!, Priority.background, scale: 0.5);
    // add an object to the scene to display
    add(background);
  }
}
