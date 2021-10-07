/*
import 'dart:ui';

import 'package:composition_rendering/engine.dart';
import 'package:composition_rendering/game.dart';

import 'demo_scene.dart';

class ExampleLauncher extends BaseGame with Registry {
  static final PluginSystemRegistry registry = SystemRegistry.instance = PluginSystemRegistry();
  final DemoScene gameScene = DemoScene();

  ExampleLauncher();

  @override
  void init() {
    // TODO: implement init
  }

  @override
  void resize(double width, double height) {
    parameters.setViewSize(width, height);
  }

  @override
  void update(double deltaTime) {
    systems.updateSystem.update(deltaTime);
    gameScene.updateScene(deltaTime);
  }

  @override
  void render(Canvas canvas, Offset offset) {
    systems.renderSystem.render(canvas);
  }
}

class PluginSystemRegistry extends SystemRegistry {
  PluginSystemRegistry() : super(parameters: Parameters(), assetSystem: PluginAssetSystem());
}

class PluginAssetSystem extends AssetSystem {
  @override
  Image? getImageFromCache(String fileName) {
    return todo; //images.fromCache(fileName);
  }

  @override
  Future<Image?> loadImage(String fileName) {
    return todo; //images.load(fileName);
  }

  @override
  Future<String> readFile(String fileName) {
    return todo; //assets.readFile(fileName);
  }

  @override
  Future<Map<String, dynamic>> readJson(String fileName) {
    return todo; //assets.readJson(fileName);
  }
}
*/
