import '../../components.dart';
import '../../graphics.dart';

class SpriteComponent extends Component with SpriteBody {
  final RenderComponent renderComponent;
  final TextureRegion textureRegion;
  final DrawableObject _drawable;

  SpriteComponent(
    this.textureRegion,
    this.renderComponent, {
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) : _drawable = DrawableObject() {
    setPhase(ComponentPhases.preDraw);
    setBody(rotation: rotation, scale: scale, opacity: opacity);
    renderComponent.drawable = _drawable;
  }

  @override
  void reset() {
    resetBody();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    if (parent is SceneObject && parent.isVisible) {
      if (spriteDirty) {
        spriteDirty = false;
        _drawable.setData(
            textureRegion: textureRegion, scale: scale, rotation: rotation, opacity: opacity);
      }
    }
  }

  @override
  String toString() {
    return 'SpriteComponent{ scale:$scale rotation:$rotation opacity:$opacity [$hashCode]}';
  }
}
