import 'package:flutter/painting.dart';

import '../core/math.dart';
import 'drawable.dart';

class DrawableText extends Drawable {
  TextPainter? textPainter;

  DrawableText();

  bool get hasTextPainter => textPainter != null;

  @override
  bool get isReady => hasTextPainter;

  @override
  bool visibleAtPosition(Vector2 screenLocation) {
    return true; //TODO
  }
}
