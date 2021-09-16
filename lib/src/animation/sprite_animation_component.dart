import '../../components.dart';
import 'animation_clip.dart';

class SpriteAnimationComponent extends SpriteComponent {
  final AnimationClip _animationClip;

  SpriteAnimationComponent(
    this._animationClip, {
    RenderComponent? render,
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) : super(_animationClip.placeholder,
            render: render, rotation: rotation, scale: scale, opacity: opacity);

  @override
  void reset() {
    super.reset();
    _animationClip.reset();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    var frame = _animationClip.getCurrentFrame();
    _animationClip.update(deltaTime, parent);
    if (frame != _animationClip.getCurrentFrame()) {
      textureRegion = _animationClip.getTextureRegion();
      spriteDirty = true;
    }
    super.update(deltaTime, parent);
  }

  void setAnimation(String name) => _animationClip.setAnimation(name);

  bool isFinished() => _animationClip.hasAnimationFinished();

  AnimationClip getAnimationClip() => _animationClip;

  void play() => _animationClip.setPlay(true);

  void stop() => _animationClip.setPlay(false);

  void gotoFrame(int frame) => _animationClip.gotoFrame(frame);

  void gotoAndPlay(int frame) {
    _animationClip
      ..gotoFrame(frame)
      ..setPlay(true);
  }

  void gotoAndStop(int frame) {
    _animationClip
      ..gotoFrame(frame)
      ..setPlay(false);
  }
}
