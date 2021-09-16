import '../core/math.dart';

abstract class Drawable {
  bool get isReady;

  bool get isNotReady => !isReady;

  bool visibleAtPosition(Vector2 screenLocation);

  @override
  String toString() {
    return 'Drawable{ ready:$isReady [$hashCode]}';
  }
}
