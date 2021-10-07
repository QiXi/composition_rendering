import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_composition_rendering/flame_composition_rendering.dart';

import 'demo_scene.dart';

class ExampleFlame extends FlameGame {
  final DemoScene gameScene = DemoScene();
  final FlamePluginComponent stageComponent = FlamePluginComponent();

  ExampleFlame() {
    stageComponent.scene = gameScene;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(['bg.jpg', 'p1.png', 'p2.png', 'bullet1.png']);
    add(stageComponent);
  }
}
