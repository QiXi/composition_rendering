import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import '../../graphics.dart';
import '../core/math.dart';

const int iscos = 0;
const int issin = 1;
const int itx = 2;
const int ity = 3;

class DrawableObject extends Drawable {
  // [scos, ssin, tx, ty]
  final Float32List data = Float32List(4);
  TextureRegion? textureRegion;
  int? color;

  DrawableObject();

  bool get hasTextureRegion => textureRegion != null;

  Image? get image => textureRegion?.texture.image;

  double get scos => data[iscos];

  double get ssin => data[issin];

  double get tx => data[itx];

  double get ty => data[ity];

  @override
  bool get notReady => textureRegion == null;

  void resetTexture() {
    textureRegion = null;
  }

  void setData(
      {required TextureRegion textureRegion,
      double rotation = 0.0,
      double scale = 1.0,
      int? color,
      double opacity = 1.0}) {
    this.textureRegion = textureRegion;
    var scos = data[iscos] = cos(rotation) * scale;
    var ssin = data[issin] = sin(rotation) * scale;
    data[itx] = -scos * textureRegion.anchorX + ssin * textureRegion.anchorY;
    data[ity] = -ssin * textureRegion.anchorX - scos * textureRegion.anchorY;
    this.color = color ?? Colors.whiteWithOpacity(opacity.clamp(0.0, 1.0));
  }

  void setDataRegion(TextureRegion textureRegion, {double tx = 0, double ty = 0}) {
    this.textureRegion = textureRegion;
    data[iscos] = 1.0;
    data[issin] = 0.0;
    data[itx] = tx;
    data[ity] = ty;
  }

  void addPositionFrom(Vector2 position) {
    data[itx] += position.x;
    data[ity] += position.y;
  }

  void addPosition(double x, double y) {
    data[itx] += x;
    data[ity] += y;
  }

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true; //TODO
  }

  @override
  String toString() {
    return 'DrawableObject{ $textureRegion data:$data [$hashCode]}';
  }
}
