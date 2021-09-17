import 'dart:typed_data';
import 'dart:ui';

import '../../core.dart';
import 'drawable.dart';
import 'texture_region.dart';

class DrawableObjectList extends Drawable {
  // [scos, ssin, tx, ty, scos, ssin, tx, ty, ...]
  Float32List? data;
  TextureRegion? textureRegion;
  int? color;

  DrawableObjectList();

  bool get hasTextureRegion => textureRegion != null;

  Image? get image => textureRegion?.texture.image;

  int get length => (data == null) ? 0 : data!.length ~/ 4;

  @override
  bool get isReady => textureRegion != null && data != null;

  void resetTexture() => textureRegion = null;

  void resetData() => data = null;

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true; //TODO
  }

  @override
  String toString() {
    return 'DrawableObjectList{ ready:$isReady $textureRegion data:$data} [$hashCode]';
  }
}
