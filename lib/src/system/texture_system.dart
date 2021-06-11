import 'dart:ui';

import '../../graphics.dart';

class TextureSystem {
  final Map<String, TextureRegion> _regions = {};

  // override in game engine
  Future<Image>? load(String src) {
    return null;
  }

  // override in game engine
  Image? getImageFromCache(String fileName) {
    return null;
  }

  TextureRegion? getTextureRegion(String fileName) {
    if (!_regions.containsKey(fileName)) {
      var image = getImageFromCache(fileName);
      if (image == null) {
        return null;
      }
      _regions[fileName] = TextureRegion(Texture(image));
    }
    return _regions[fileName];
  }
}
