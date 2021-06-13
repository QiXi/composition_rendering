import '../../components.dart';
import '../../graphics.dart';

class SpriteComponent extends Component with SpriteBody {
  final RenderComponent _renderComponent;
  final TextureRegion textureRegion;
  final DrawableObject _drawable;

  SpriteComponent(
    this.textureRegion,
    this._renderComponent, {
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) : _drawable = DrawableObject() {
    setPhase(ComponentPhases.preDraw);
    setBody(rotation: rotation, scale: scale, opacity: opacity);
    _renderComponent.drawable = _drawable;
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
            textureRegion: textureRegion, rotation: rotation, scale: scale, opacity: opacity);
      }
    }
  }

  @override
  String toString() {
    return 'SpriteComponent{ rotation:$rotation scale:$scale opacity:$opacity [$hashCode]}';
  }
}
