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

  @override
  void update(double deltaTime, BaseObject parent) {
    if (drawable == null || drawable!.notReady) {
      return;
    }
    if (parent is SceneObject && parent.isVisible) {
      _positionWorkspace.setFrom(parent.position);
      _positionWorkspace.add(drawOffset);
      if (cameraRelative) {
        final focusPosition = systems.cameraSystem.focusPosition;
        final params = systems.parameters;
        final x = _positionWorkspace.x - focusPosition.x + params.viewHalfWidth;
        final y = _positionWorkspace.y - focusPosition.y + params.viewHalfHeight;
        _screenLocation.setValues(x, y);
      }
      if (drawable!.visibleAtPosition(_screenLocation)) {
        systems.renderSystem.draw(
            drawable: drawable!,
            position: _positionWorkspace,
            priority: priority,
            cameraRelative: cameraRelative);
      }
    }
  }

  @override
  String toString() {
    return 'RenderComponent{ priority:$priority cameraRelative:$cameraRelative [$hashCode]}';
  }
}
