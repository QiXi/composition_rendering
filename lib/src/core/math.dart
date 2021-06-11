import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

export 'package:vector_math/vector_math_64.dart' show Vector2;

const double twoPi = pi * 2;

bool positionInRect(Vector2 position, Rect rect) {
  return position.x >= rect.left &&
      position.x <= rect.right &&
      position.y >= rect.top &&
      position.y <= rect.bottom;
}

bool coordinatesInRect(double x, double y, Rect rect) {
  return x >= rect.left && x <= rect.right && y >= rect.top && y <= rect.bottom;
}
