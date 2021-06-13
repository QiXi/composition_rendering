import 'dart:ui';

abstract class AssetSystem {
  // override in game engine
  Future<Image?> loadImage(String src);

  // override in game engine
  Image? getImageFromCache(String fileName);

  // override in game engine
  Future<Map<String, dynamic>> readJson(String fileName);

  // override in game engine
  Future<String> readFile(String fileName);
}

class InternalAssetSystem extends AssetSystem {
  @override
  Image? getImageFromCache(String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<Image?> loadImage(String src) {
    throw UnimplementedError();
  }

  @override
  Future<String> readFile(String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> readJson(String fileName) {
    throw UnimplementedError();
  }
}
