import '../core/math.dart';

abstract class Drawable {
  bool get isReady;

  bool visibleAtPosition(Vector2 screenLocation);

  @override
  String toString() {
    return 'Drawable{ ready:$isReady [$hashCode]}';
  }
}
