import 'dart:ui';

import '../core/math.dart';

class Texture {
  final Image image;
  final Vector2 _size;
  final int sortIndex;

  Texture(this.image)
      : _size = Vector2(image.width.toDouble(), image.height.toDouble()),
        sortIndex = image.hashCode % 100;

  Vector2 get size => _size;
}
