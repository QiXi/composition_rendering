import '../../components.dart';
import '../../graphics.dart';

class SpriteListComponent extends Component with SpriteBody {
  final List<TextureRegion> _textureRegions;
  final RenderListComponent _renderComponent;
  final List<DrawableObject> _drawableList;

  SpriteListComponent({
    required int size,
    required List<TextureRegion> textureRegions,
    required RenderListComponent renderComponent,
    double rotation = 0.0,
    double scale = 1.0,
    double opacity = 1.0,
  })  : _drawableList = [],
        _renderComponent = renderComponent,
        _textureRegions = textureRegions {
    setPhase(ComponentPhases.preDraw);
    setBody(rotation: rotation, scale: scale, opacity: opacity);
    for (var i = 0; i < size; i++) {
      _drawableList.add(DrawableObject());
    }
    _renderComponent.drawableList = _drawableList;
  }

  @override
  void reset() {
    resetBody();
  }

  TextureRegion? getTextureRegion(int index) {
    if (index < 0 || index >= _textureRegions.length) return null;
    return _textureRegions[index];
  }

  int get drawableCount => _drawableList.length;

  DrawableObject? getDrawableObject(int index) {
    if (index < 0 || index >= _drawableList.length) return null;
    return _drawableList[index];
  }

  Iterable<DrawableObject> getDrawableList() => _drawableList;

  @override
  void update(double deltaTime, BaseObject parent) {
    if (parent is SceneObject && parent.isVisible) {
      if (spriteDirty) {
        spriteDirty = false;
        for (var i = 0; i < _textureRegions.length; i++) {
          var drawable = _drawableList[i];
          var textureRegion = getTextureRegion(i);
          if (textureRegion != null) {
            drawable.setData(
                textureRegion: textureRegion, scale: scale, rotation: rotation, opacity: opacity);
          }
        }
      }
    }
  }

  @override
  String toString() {
    return 'SpriteListComponent{[$hashCode]}';
  }
}
