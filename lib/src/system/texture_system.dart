import 'dart:ui';

import 'package:composition_rendering/systems.dart';

import '../../graphics.dart';

class TextureSystem with Registry {
  final Map<String, TextureRegion> _regions = {};

  Image? getImageFromCache(String fileName) {
    return systems.assetSystem.getImageFromCache(fileName);
  }

  TextureRegion? getTextureRegion(String fileName) {
    if (!_regions.containsKey(fileName)) {
      var image = systems.assetSystem.getImageFromCache(fileName);
      if (image == null) {
        return null;
      }
      _regions[fileName] = TextureRegion(Texture(image));
    }
    return _regions[fileName];
  }

  Future<void> loadSpriteSheetFromJson(String imagePath, String jsonPath) async {
    final image = await systems.assetSystem.loadImage(imagePath);
    final texture = Texture(image!);
    final json = await systems.assetSystem.readJson(jsonPath);
    final List<dynamic> jsonFrames = json['frames'];
    for (var value in jsonFrames) {
      final fileName = value['filename'];
      final frameData = value['frame'];
      final int left = frameData['x'];
      final int top = frameData['y'];
      final int width = frameData['w'];
      final int height = frameData['h'];
      final rect =
          Rect.fromLTWH(left.toDouble(), top.toDouble(), width.toDouble(), height.toDouble());
      _regions[fileName] = TextureRegion(texture, regionRect: rect);
    }
  }
}
