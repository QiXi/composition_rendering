import 'dart:ui';

import 'package:flutter/painting.dart';

import '../../core.dart';
import '../../graphics.dart';
import '../../systems.dart';
import '../core/math.dart';

class TextSystem with Registry {
  //
  void drawText(
      {required DrawableText drawable,
      required Vector2 position,
      required int priority,
      bool cameraRelative = true}) {
    if (drawable.isNotReady) {
      return;
    }
    drawTextPainter(
        textPainter: drawable.textPainter!,
        position: position,
        priority: priority,
        cameraRelative: cameraRelative);
  }

  void drawTextPainter(
      {required TextPainter textPainter,
      required Vector2 position,
      required int priority,
      bool cameraRelative = true}) {
    var x = position.x;
    var y = position.y;
    if (cameraRelative) {
      var focusPosition = systems.cameraSystem.focusPosition;
      x += -focusPosition.x + parameters.viewHalfWidth;
      y += -focusPosition.y + parameters.viewHalfHeight;
    }
    systems.renderSystem
        .drawTextElement(TextElement(priority, textPainter: textPainter, dx: x, dy: y));
  }
}

class TextElement extends PhasedObject {
  final TextPainter textPainter;
  double dx;
  double dy;

  TextElement(int priority, {required this.textPainter, this.dx = 0, this.dy = 0})
      : super(phase: priority * RenderSystem.textureSortBucketSize);

  @override
  void reset() {}

  void paint(Canvas canvas) {
    textPainter.paint(canvas, Offset(dx, dy));
  }

  @override
  String toString() {
    return '\nTextElement{ text:${textPainter.text} dx:$dx dy:$dy [$hashCode]}';
  }
}
