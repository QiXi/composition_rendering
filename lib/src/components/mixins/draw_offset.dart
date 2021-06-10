import '../../core/math.dart';

mixin DrawOffset {
  final Vector2 drawOffset = Vector2.zero();

  void setDrawOffset(double x, double y) {
    drawOffset.setValues(x, y);
  }

  void setDrawOffsetFrom(Vector2 offset) {
    drawOffset.setFrom(offset);
  }
}
