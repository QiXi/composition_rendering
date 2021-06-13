mixin SpriteBody {
  double _rotation = 0.0;
  double _scale = 1.0;
  double _opacity = 1.0;
  bool _dirty = true;

  void setBody({double rotation = 0.0, double scale = 1.0, double opacity = 1.0}) {
    _rotation = rotation;
    _scale = scale;
    _opacity = opacity;
    _dirty = true;
  }

  void resetBody() {
    _rotation = 0.0;
    _scale = 1.0;
    _opacity = 1.0;
    _dirty = true;
  }

  double get rotation => _rotation;

  set rotation(double rotation) {
    if (_rotation != rotation) {
      _dirty = true;
      _rotation = rotation;
    }
  }

  double get scale => _scale;

  set scale(double scale) {
    if (_scale != scale) {
      _dirty = true;
      _scale = scale;
    }
  }

  double get opacity => _opacity;

  set opacity(double opacity) {
    if (_opacity != opacity) {
      _dirty = true;
      _opacity = opacity;
    }
  }

  bool get spriteDirty => _dirty;

  bool get spriteNotDirty => !_dirty;

  set spriteDirty(bool value) => _dirty = value;
}
