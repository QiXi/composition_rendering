import 'dart:ui';

class Colors {
  static final int white = 0xffffffff;
  static final int black = 0xff000000;
  static final Color whiteColor = Color(white);
  static final Color blackColor = Color(black);

  static int whiteWithOpacity(double opacity) => whiteWithAlpha((255.0 * opacity).round());

  static int whiteWithAlpha(int a) => ((a & 0xff) << 24) & white;
}
