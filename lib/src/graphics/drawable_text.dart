import 'package:flutter/painting.dart';

import '../core/math.dart';
import 'drawable.dart';

class DrawableText extends Drawable {
  TextPainter? textPainter;

  bool get hasTextPainter => textPainter != null;

  DrawableText();

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true; //TODO
  }

  @override
  bool get notReady => textPainter == null;
}
