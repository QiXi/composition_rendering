import '../../components.dart';
import '../../graphics.dart';
import '../core/math.dart';

class RenderComponent extends Component with DrawOffset {
  final Vector2 _positionWorkspace;
  final Vector2 _screenLocation;
  int priority;
  bool cameraRelative;
  Drawable? drawable;

  RenderComponent(this.priority, {this.cameraRelative = true})
      : _positionWorkspace = Vector2.zero(),
        _screenLocation = Vector2.zero() {
    setPhase(ComponentPhases.draw);
  }

  @override
  void reset() {
    _positionWorkspace.setZero();
    _screenLocation.setZero();
    drawOffset.setZero();
    drawable = null;
  }

  // performance 100%
  @override
  void update(double deltaTime, BaseObject parent) {
    var drawable = this.drawable;
    if (drawable == null || !drawable.isReady) {
      return;
    }
    var positionWorkspace = _positionWorkspace;
    if (parent is SceneObject && parent.isVisible) {
      positionWorkspace
        ..setFrom(parent.position)
        ..add(drawOffset); // 25%
      if (cameraRelative) {
        final focusPosition = systems.cameraSystem.focusPosition;
        final params = systems.parameters;
        final x = positionWorkspace.x - focusPosition.x + params.viewHalfWidth;
        final y = positionWorkspace.y - focusPosition.y + params.viewHalfHeight;
        _screenLocation.setValues(x, y);
      }
      if (drawable.visibleAtPosition(_screenLocation)) {
        systems.renderSystem.draw(
            drawable: drawable,
            position: positionWorkspace,
            priority: priority,
            cameraRelative: cameraRelative); // 40%
      }
    }
  }

  @override
  String toString() {
    return 'RenderComponent{ priority:$priority cameraRelative:$cameraRelative offset:$drawOffset [$hashCode]}';
  }
}
