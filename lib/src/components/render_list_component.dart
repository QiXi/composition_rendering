import '../../components.dart';
import '../core/math.dart';
import '../graphics/drawable_object.dart';

class RenderListComponent extends Component with DrawOffset {
  final Vector2 _positionWorkspace;
  final Vector2 _screenLocation;
  final List<int> priorityList;
  int priority;
  bool cameraRelative;
  List<DrawableObject>? _drawableList;

  RenderListComponent(this.priority, {this.cameraRelative = true})
      : priorityList = [],
        _positionWorkspace = Vector2.zero(),
        _screenLocation = Vector2.zero() {
    setPhase(ComponentPhases.draw);
  }

  @override
  void reset() {
    _positionWorkspace.setZero();
    _screenLocation.setZero();
    drawOffset.setZero();
    _drawableList = null;
  }

  set drawableList(List<DrawableObject> drawableList) {
    _drawableList = drawableList;
    priorityList.clear();
    for (var i = 0; i < drawableList.length; i++) {
      priorityList.add(priority);
    }
  }

  @override
  void update(double timeDelta, BaseObject parent) {
    if (_drawableList == null) {
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
      for (var i = 0; i < _drawableList!.length; i++) {
        var drawable = _drawableList![i];
        if (drawable.hasTextureRegion && drawable.visibleAtPosition(_screenLocation)) {
          systems.renderSystem.drawObject(
              drawable: drawable,
              position: _positionWorkspace,
              priority: priorityList[i],
              cameraRelative: cameraRelative);
        }
      }
    }
  }

  @override
  String toString() {
    return 'RenderListComponent{ priority:$priority cameraRelative:$cameraRelative offset:$drawOffset [$hashCode]}';
  }
}
