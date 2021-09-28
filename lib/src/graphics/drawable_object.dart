import 'dart:math';
import 'dart:ui';

import '../../core.dart';
import '../core/math.dart';
import 'colors.dart';
import 'drawable.dart';
import 'texture_region.dart';

class DrawableObject extends Drawable {
  final TransformData data;
  TextureRegion? textureRegion;
  int? color;

  DrawableObject() : data = TransformData.allocate();

  bool get hasTextureRegion => textureRegion != null;

  Image? get image => textureRegion?.texture.image;

  double get scos => data.scos;

  double get ssin => data.ssin;

  double get tx => data.tx;

  double get ty => data.ty;

  @override
  bool get isReady => textureRegion != null;

  void reset() {
    data.release();
    resetTexture();
  }

  void resetTexture() => textureRegion = null;

  void setData(
      {required TextureRegion textureRegion,
      double rotation = 0.0,
      double scale = 1.0,
      int? color,
      double opacity = 1.0}) {
    this.textureRegion = textureRegion;
    var scos = cos(rotation) * scale;
    var ssin = sin(rotation) * scale;
    var tx = -scos * textureRegion.anchorX + ssin * textureRegion.anchorY;
    var ty = -ssin * textureRegion.anchorX - scos * textureRegion.anchorY;
    data.set(scos, ssin, tx, ty);
    this.color = color ?? Colors.whiteWithOpacity(opacity.clamp(0.0, 1.0));
  }

  void setDataRegion(TextureRegion textureRegion,
      {double tx = 0, double ty = 0}) {
    this.textureRegion = textureRegion;
    data.set(1.0, 0.0, tx, ty);
  }

  void addPositionFrom(Vector2 position) {
    data.set(data.scos, data.ssin, data.tx + position.x, data.ty + position.y);
  }

  void addPosition(double x, double y) {
    data.set(data.scos, data.ssin, data.tx + x, data.ty + y);
  }

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true; //TODO
  }

  @override
  String toString() {
    return 'DrawableObject{ ready:$isReady $textureRegion data:$data [$hashCode]}';
  }
}
