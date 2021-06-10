import '../core/math.dart';

abstract class Drawable {
  bool get notReady;

  bool visibleAtPosition(Vector2 screenLocation);

  @override
  String toString() {
    return 'Drawable{[$hashCode]]}';
  }
}
