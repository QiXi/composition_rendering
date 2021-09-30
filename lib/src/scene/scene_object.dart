import '../../engine.dart';
import '../core/math.dart';

class SceneObject extends ObjectManager<Component> {
  final Vector2 position;
  bool _visible;
  bool destroyOnDeactivation = false;
  Scene? scene;
  double width = 0;
  double height = 0;

  SceneObject({Vector2? position})
      : this.position = position ?? Vector2.zero(),
        _visible = true;

  @override
  void reset() {
    super.reset();
    position.setZero();
    _visible = false;
    destroyOnDeactivation = false;
    scene = null;
    width = 0;
    height = 0;
  }

  void setPosition(double x, double y) {
    position.setValues(x, y);
  }

  bool get isVisible => _visible;

  set visible(bool visible) => _visible = visible;

  double getCenteredPositionX() {
    return position.x;
  }

  double getCenteredPositionY() {
    return position.y;
  }

  void spawn() {
    var list = getAdditionsArray();
    final length = list.length;
    for (int i = 0; i < length; i++) {
      var element = list[i];
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
    return 'SceneObject{ position:$position width:$width height:$height'
        ' additions:${getAdditionsArray()} [$hashCode]}';
  }
}
