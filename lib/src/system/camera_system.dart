import '../../core.dart';
import '../../scene.dart';
import '../../systems.dart';

class CameraSystem with Registry {
  static const double interpolateToTargetTime = 1.0;
  static const double maxInterpolateToTargetDistance = 1000.0;
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

  Vector2 get cameraPosition => _currentCameraPosition;

  void update(double deltaTime) {
    _currentTime += deltaTime;
    final target = _target;
    if (target != null) {
      _targetPosition.setValues(target.getCenteredPositionX(), target.getCenteredPositionY());
      // extra time to reach the end point
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
        applyBounds(_focalPosition, _currentCameraPosition);
      } else {
        _focalPosition.setFrom(_currentCameraPosition);
      }
    }
  }

  void applyBounds(Vector2 focalPosition, Vector2 cameraPosition) {
    final params = systems.parameters;
    final worldBounds = params.worldBounds;
    final hw = params.viewHalfWidth;
    final hh = params.viewHalfHeight;
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
  }

  bool visibleAtPosition(Vector2 position) {
    final x = position.x - _focalPosition.x;
    final y = position.y - _focalPosition.y;
    return coordinatesInRect(x, y, systems.parameters.viewRect);
  }

  @override
  String toString() {
    return '[CameraSystem] position:$_currentCameraPosition targetPosition:$_targetPosition';
  }
}
