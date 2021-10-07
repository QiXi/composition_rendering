import 'dart:ui';

import 'package:composition_rendering/engine.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_composition_rendering/flame_composition_rendering.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import 'components/rotation_component.dart';

//
class ExampleBenchmark extends FlameGame with FPSCounter {
  final Scene gameScene = Benchmark();
  final FlamePluginComponent stageComponent = FlamePluginComponent();

  ExampleBenchmark() {
    stageComponent.scene = gameScene;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll(['element.png']);
    add(stageComponent);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final fpsCount = fps(120);
    textPaint.render(
        canvas,
        'fps:${fpsCount.ceilToDouble()} '
        ' objects:${gameScene.count}',
        math.Vector2.zero());
  }
}

//
class Benchmark extends Scene {
  final GameFactory gameFactory = GameFactory();

  @override
  void init() {
    var count = 1000;
    var size = sqrt(count);
    int step = 10;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        add(gameFactory.spawnElement('element.png')
          ..position.setValues(25 + i * step * 2, 25 + j * step * 1));
      }
    }
  }
}

//
class GameFactory with Registry {
  FactorySystem get factory => systems.factorySystem;

  TextureSystem get textures => systems.textureSystem;

  SceneObject spawnElement(String fileName) {
    var texture = textures.getTextureRegion(fileName);

    return factory.spawnSprite(texture!, Priority.backgroundObject, scale: 0.5, rotation: 1)
      ..add(RotationComponent())
      ..spawn();
  }
}

const TextPaintConfig regular =
    TextPaintConfig(color: Color(0xFFFFFFFF), textDirection: TextDirection.ltr, fontSize: 9);
TextPaint textPaint = TextPaint(config: regular);
