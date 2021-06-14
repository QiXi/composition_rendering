import 'dart:typed_data';
import 'dart:ui';

import 'texture.dart';

class TextureRegion {
  final Texture texture;
  final Rect rect;
  late final Float32List rawRect;
  double anchorX = 0;
  double anchorY = 0;

  TextureRegion(this.texture, {Rect? regionRect})
      : rect = regionRect ?? Rect.fromLTWH(0, 0, texture.size.x, texture.size.y) {
    _init();
  }

  TextureRegion.fromImage(Image image, Rect regionRect)
      : texture = Texture(image),
        rect = regionRect {
    _init();
  }

  void _init() {
    rawRect = Float32List.fromList(<double>[rect.left, rect.top, rect.right, rect.bottom]);
    anchorX = rect.width / 2.0;
    anchorY = rect.height / 2.0;
  }

  Image get image => texture.image;

  @override
  String toString() {
    return 'TextureRegion{ rect[${rect.left.round()},${rect.top.round()},${rect.width.round()},${rect.height.round()}] anchor[${anchorX.round()},${anchorY.round()}] [$hashCode]}';
  }
}
