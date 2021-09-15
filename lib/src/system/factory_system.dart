import 'dart:ui';

import '../../components.dart';
import '../../graphics.dart';
import '../../scene.dart';
import 'registry.dart';

class FactorySystem with Registry {
  //
  SceneObject buildSprite(
    TextureRegion textureRegion,
    int priority, {
    bool cameraRelative = true,
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) {
    var renderComponent = RenderComponent(priority, cameraRelative: cameraRelative);
    var spriteComponent = SpriteComponent(textureRegion, renderComponent,
        rotation: rotation, scale: scale, opacity: opacity);
    return SceneObject()
      ..add(renderComponent)
      ..add(spriteComponent);
  }

  SceneObject spawnSprite(
    TextureRegion textureRegion,
    int priority, {
    bool cameraRelative = true,
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) {
    return buildSprite(textureRegion, priority,
        cameraRelative: cameraRelative, rotation: rotation, scale: scale, opacity: opacity)
      ..spawn();
  }

  List<TextureRegion> spawnTextureRegionsFromLine(
      {required String fileName, required int tileSize, required int count}) {
    final regions = <TextureRegion>[];
    var image = systems.textureSystem.getImageFromCache(fileName);
    var left = 0;
    for (var i = 0; i < count; i++) {
      var rect = Rect.fromLTWH(left.toDouble(), 0, tileSize.toDouble(), tileSize.toDouble());
      left += tileSize;
      regions.add(TextureRegion.fromImage(image!, rect));
    }
    return regions;
  }
}
