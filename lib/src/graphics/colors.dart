import 'dart:ui';

class Colors {
  static const int white = 0xffffffff;
  static const int black = 0xff000000;
  static const Color whiteColor = Color(white);
  static const Color blackColor = Color(black);

  static int whiteWithOpacity(double opacity) {
    return whiteWithAlpha(clamp((255.0 * opacity).toInt()));
  }

  static int clamp(int value, [int lowerLimit = 0, int upperLimit = 255]) {
    var clamp = value < lowerLimit ? lowerLimit : value;
    return clamp > upperLimit ? upperLimit : clamp;
  }

  static int whiteWithAlpha(int a) {
    return ((a & 0xff) << 24) & white;
  }
}
