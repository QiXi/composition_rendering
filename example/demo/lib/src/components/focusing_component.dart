import 'package:composition_rendering/components.dart';
import 'package:composition_rendering/scene.dart';

class FocusingComponent extends Component {
  final List<SceneObject> targets;
  int _targetIndex = 0;
  double _currentTime = 0;
  double _targetTime = 0;
  double startTime;
  double interval;
  bool looping;

  FocusingComponent(
      {required this.targets,
      this.startTime = 0,
      this.looping = false,
      this.interval = 2}) {
    _targetTime = startTime;
  }

  @override
  void reset() {
    _currentTime = 0;
    _targetIndex = 0;
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    _currentTime += deltaTime;
    if (_currentTime > _targetTime) {
      _targetTime = _currentTime + interval;
      systems.cameraSystem
          .setTarget(targets[_targetIndex], useWorldBounds: false);
      _targetIndex++;
      if (_targetIndex >= targets.length) {
        if (looping) {
          _targetIndex = 0;
        } else if (parent is SceneObject) {
          parent.destroy();
        }
      }
    }
  }

  @override
  String toString() {
    return 'FocusingComponent{ interval:$interval looping:$looping [$hashCode]}';
  }
}
