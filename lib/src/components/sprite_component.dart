import '../../components.dart';
import '../../graphics.dart';

class SpriteComponent extends Component with SpriteBody {
  RenderComponent? _renderComponent;
  TextureRegion textureRegion;
  final DrawableObject drawable = DrawableObject();

  SpriteComponent(
    this.textureRegion, {
    RenderComponent? render,
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  }) : _renderComponent = render {
    setPhase(ComponentPhases.preDraw);
    setBody(rotation: rotation, scale: scale, opacity: opacity);
    _renderComponent?.drawable = drawable;
  }

  @override
  void reset() {
    resetBody();
    drawable.reset();
  }

  @override
  void update(double deltaTime, BaseObject parent) {
    if (parent is SceneObject && parent.isVisible) {
      if (spriteDirty) {
        spriteDirty = false;
        drawable.setData(
            textureRegion: textureRegion, rotation: rotation, scale: scale, opacity: opacity);
      }
    }
  }

  @override
  void spawn(BaseObject parent) {
    if (_renderComponent == null && parent is SceneObject) {
      var render = parent.findByType<RenderComponent>();
      _renderComponent = render;
      _renderComponent?.drawable = drawable;
    }
  }

  void setRenderComponent(RenderComponent component) {
    _renderComponent = component..drawable = drawable;
  }

  @override
  String toString() {
    return 'SpriteComponent{ rotation:$rotation scale:$scale opacity:$opacity [$hashCode]}';
  }
}
