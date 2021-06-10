import '../../core.dart';
import '../../scene.dart';
import '../../systems.dart';

class CameraSystem with Registry {
  static final double interpolateToTargetTime = 1.0;
  static final double maxInterpolateToTargetDistance = 1000.0;
  final Vector2 _currentCameraPosition = Vector2.zero();
  final Vector2 _preInterpolateCameraPosition = Vector2.zero();
  final Vector2 _focalPosition = Vector2.zero();
  final Vector2 _targetPosition = Vector2.zero();
  SceneObject? _target;

  double _currentTime = 0;
  double _targetTime = 0;
  bool _useWorldBounds = true;

  void reset() {
    _currentCameraPosition.setZero();
    _preInterpolateCameraPosition.setZero();
    _focalPosition.setZero();
    _targetPosition.setZero();
    _target = null;
  }

  void setTarget(SceneObject target, {useWorldBounds = true}) {
    //print('setTarget $target');
    if (_target != target) {
      _useWorldBounds = useWorldBounds;
      _preInterpolateCameraPosition.setFrom(_currentCameraPosition);
      if (_preInterpolateCameraPosition.length2 <
          maxInterpolateToTargetDistance * maxInterpolateToTargetDistance) {
        _targetTime = _currentTime + interpolateToTargetTime;
      } else {
        _targetTime = 0;
        _currentCameraPosition.setFrom(target.position);
      }
      _target = target;
    }
  }

  SceneObject? get target => _target;

  Vector2 get focusPosition => _focalPosition;

  void update(double deltaTime) {
    _currentTime += deltaTime;
    if (_target != null) {
      _targetPosition.setValues(_target!.getCenteredPositionX(), _target!.getCenteredPositionY());
      if (_targetTime > _currentTime - 0.05) {
        final delta = _currentTime - (_targetTime - interpolateToTargetTime);
        _currentCameraPosition.x = Lerp.ease(
            _preInterpolateCameraPosition.x, _targetPosition.x, interpolateToTargetTime, delta);
        _currentCameraPosition.y = Lerp.ease(
            _preInterpolateCameraPosition.y, _targetPosition.y, interpolateToTargetTime, delta);
      } else {
        _currentCameraPosition.setFrom(_targetPosition);
      }
      if (_useWorldBounds) {
        applyBounds(_currentCameraPosition, _currentCameraPosition);
      }
    }
    _focalPosition.setFrom(_currentCameraPosition);
  }

  void applyBounds(Vector2 focalPosition, Vector2 cameraPosition) {
    final worldBounds = systems.parameters.worldBounds;
    final hw = systems.parameters.viewHalfWidth;
    final hh = systems.parameters.viewHalfHeight;
    if (cameraPosition.x + hw > worldBounds.right) {
      focalPosition.x = worldBounds.right - hw;
    } else if (cameraPosition.x - hw < worldBounds.left) {
      focalPosition.x = worldBounds.left + hw;
    }
    if (cameraPosition.y - hh < worldBounds.top) {
      focalPosition.y = worldBounds.top + hh;
    } else if (cameraPosition.y + hh > worldBounds.bottom) {
      focalPosition.y = worldBounds.bottom - hh;
    }
    /*var w = worldBounds.right - hw;
    var h = worldBounds.bottom - hh;
    var length2 = w * w + h * h;
    if (cameraPosition.length2 > length2) {
      var angle = atan2(cameraPosition.y, cameraPosition.x);
      var x = w * cos(angle);
      var y = h * sin(angle);
      focalPosition.setValues(x, y);
    } else {
      focusPosition.setFrom(cameraPosition);
    }*/
  }

  @override
  String toString() {
    return '[CameraSystem] currentPosition:$_currentCameraPosition targetPosition:$_targetPosition';
  }
}
