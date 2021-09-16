import '../../core.dart';
import '../../graphics.dart';
import 'animation_data.dart';
import 'animation_sequence.dart';

class AnimationClip extends BaseObject {
  final AnimationData _data;
  final TextureRegion placeholder;
  int _currentIndex = 0;
  int _currentFrame = 0;
  bool _isPlaying = false;
  double _waitTime = 0;
  AnimationSequence? _currentState;

  AnimationClip(this._data, this.placeholder);

  @override
  void reset() {
    _data.reset();
    _currentIndex = 0;
    _currentFrame = 0;
    _isPlaying = false;
    _waitTime = 0;
    _currentState = null;
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    if (!_isPlaying) return;
    var sequence = _currentState;
    if (_waitTime < 0 && sequence != null) {
      if (_currentIndex >= totalFrame - 1) {
        if (sequence.loop) {
          _currentIndex = 0;
          _updateFrame(sequence);
        }
      } else {
        _currentIndex++;
        _updateFrame(sequence);
      }
    } else if (_waitTime > 0) {
      _waitTime -= deltaTime;
    }
  }

  void _updateFrame(AnimationSequence sequence) {
    _waitTime = 1.0 / sequence.frameRate;
    _currentFrame = sequence.frames[_currentIndex];
  }

  TextureRegion getTextureRegion() {
    if (_currentState == null) {
      return placeholder;
    }
    return _data.getTextureRegion(_currentState!.name, _currentFrame) ?? placeholder;
  }

  int getCurrentFrame() => _currentFrame;

  int gotoFrame(int frame) {
    if (frame < 0) {
      return _currentIndex = 0;
    } else if (frame >= totalFrame) {
      return _currentIndex = totalFrame - 1;
    } else {
      return _currentIndex = frame;
    }
  }

  int nextFrame() => gotoFrame(_currentFrame + 1);

  int prevFrame() => gotoFrame(_currentFrame - 1);

  bool hasAnimationFinished() {
    if (_currentState == null) {
      return true;
    }
    return (_currentIndex == (totalFrame - 1) && !_currentState!.loop && _waitTime <= 0);
  }

  void setAnimation(String name) {
    _currentIndex = 0;
    var sequence = _data.getAnimationSequence(name);
    if (sequence != null) {
      _currentState = sequence;
      _updateFrame(sequence);
    }
  }

  String? getAnimationName() => _currentState?.name;

  int get totalFrame => _currentState?.frames.length??0;

  void setPlay(bool value) => _isPlaying = value;

  void playAnimation(String name) {
    setAnimation(name);
    _isPlaying = true;
  }

  void stopAnimation() {
    _isPlaying = false;
  }
}
