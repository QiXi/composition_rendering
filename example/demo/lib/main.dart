import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_composition_rendering/flame_composition_rendering.dart';
import 'package:flutter/material.dart';

import 'src/demo_scene.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(
    GameWidget(
      game: ExampleLauncher(),
    ),
  );
}

class ExampleLauncher extends FlameGame {
  final DemoScene gameScene = DemoScene();
  final FlamePluginComponent stageComponent = FlamePluginComponent();

  ExampleLauncher() {
    stageComponent.scene = gameScene;
  }

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll(['bg.jpg', 'p1.png', 'p2.png', 'bullet1.png']);
    add(stageComponent);
  }
}
