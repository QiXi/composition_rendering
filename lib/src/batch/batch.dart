import 'dart:typed_data';
import 'dart:ui';

import '../../graphics.dart';

abstract class Batch {
  void beginBatch(Canvas canvas, {Rect? cullRect});

  void endBatch();

  void drawTextureRegion(TextureRegion textureRegion, Float32List data, int? color);

  void drawTextureRegionFromData(
      TextureRegion textureRegion, double scos, double ssin, double tx, double ty, int? color);

  void drawImage(Image image, Float32List data, Float32List rect, int? color);

  void drawImages(Image image, Float32List data, Float32List rect, int? color);

  void drawImageFromData(
      Image image, Rect rect, double scos, double ssin, double tx, double ty, int? color);

  void drawImageFromComponents(
      {required Image image,
      required Rect rect,
      required double rotation,
      required double scale,
      required double anchorX,
      required double anchorY,
      required double translateX,
      required double translateY});
}
