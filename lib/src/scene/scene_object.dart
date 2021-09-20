import '../../engine.dart';
import '../core/math.dart';

class SceneObject extends ObjectManager<Component> {
  final Vector2 _position;
  bool _visible;
  bool destroyOnDeactivation = false;
  Scene? scene;
  double width = 0;
  double height = 0;

  SceneObject({Vector2? position})
      : _position = position ?? Vector2.zero(),
        _visible = true;

  @override
  void reset() {
    _position.setZero();
    _visible = true;
  }

  Vector2 get position => _position;

  set position(Vector2 position) {
    _position.setFrom(position);
  }

  void setPosition(double x, double y) {
    _position.setValues(x, y);
  }

  bool get isVisible => _visible;

  set visible(bool visible) => _visible = visible;

  double getCenteredPositionX() {
    return _position.x;
  }

  double getCenteredPositionY() {
    return _position.y;
  }

  void spawn() {
    var list = getAdditionsArray();
    for (var element in list) {
      element.spawn(this);
    }
  }

  void show() => _visible = true;

  void hide() => _visible = false;

  void destroy() {
    destroyOnDeactivation = true;
  }

  Component? findComponentByName(String name) {
    final length = count;
    for (var i = 0; i < length; i++) {
      var component = getAt(i);
      if (name == component.componentName) {
        return component;
      }
    }
  }

  @override
  String toString() {
    return 'SceneObject{ position:$_position width:$width height:$height additions:${getAdditionsArray()} [$hashCode]}';
  }
}
