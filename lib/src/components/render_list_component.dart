import '../../components.dart';
import '../../graphics.dart';
import '../core/math.dart';

class RenderListComponent extends Component with DrawOffset {
  final Vector2 _positionWorkspace;
  final Vector2 _screenLocation;
  int priority;
  bool cameraRelative;
  List<DrawableObject>? drawableList;

  RenderListComponent(this.priority, {this.cameraRelative = true})
      : _positionWorkspace = Vector2.zero(),
        _screenLocation = Vector2.zero() {
    setPhase(ComponentPhases.draw);
  }

  @override
  void reset() {
    _positionWorkspace.setZero();
    _screenLocation.setZero();
    drawOffset.setZero();
    drawableList = null;
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    var drawableList = this.drawableList;
    if (drawableList != null) {
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
        for (var i = 0; i < drawableList.length; i++) {
          var drawable = drawableList[i];
          if (drawable.isReady && drawable.visibleAtPosition(_screenLocation)) {
            systems.renderSystem.drawObject(
                drawable: drawable,
                position: _positionWorkspace,
                priority: priority + i,
                cameraRelative: cameraRelative);
          }
        }
      }
    }
  }

  @override
  String toString() {
    return 'RenderListComponent{ priority:$priority cameraRelative:$cameraRelative offset:$drawOffset [$hashCode]}';
  }
}
