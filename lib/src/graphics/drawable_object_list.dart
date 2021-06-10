import 'dart:typed_data';

import '../../core.dart';
import '../../graphics.dart';
import 'drawable.dart';

class DrawableObjectList extends Drawable {
  // [scos, ssin, tx, ty, scos, ssin, tx, ty, ...]
  Float32List? data;
  TextureRegion? textureRegion;
  int? color;

  DrawableObjectList();

  bool get hasTextureRegion => textureRegion != null;

  int get length => (data == null) ? 0 : data!.length ~/ 4;

  void resetTexture() {
    textureRegion = null;
  }

  void resetData() {
    data = null;
  }

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true;
  }

  @override
  bool get notReady => textureRegion == null || data == null;

  @override
  String toString() {
    return 'DrawableObjectList{ textureRegion:$textureRegion data:$data} [$hashCode]';
  }
}
