import 'dart:ui';

class Parameters {
  late double _viewWidth;
  late double _viewHalfWidth;
  late double _viewHeight;
  late double _viewHalfHeight;
  late Rect viewRect;

  double gameWidth;
  double gameHeight;
  Rect worldBounds;

  Parameters(
      {double viewWidth = 0, double viewHeight = 0, this.gameWidth = 1000, this.gameHeight = 1000})
      : worldBounds =
            Rect.fromLTRB(-gameWidth / 2.0, -gameHeight / 2.0, gameWidth / 2.0, gameHeight / 2.0) {
    setViewSize(viewWidth, viewHeight);
  }

  double get viewWidth => _viewWidth;

  double get viewHalfWidth => _viewHalfWidth;

  double get viewHeight => _viewHeight;

  double get viewHalfHeight => _viewHalfHeight;

  void setViewSize(double width, double height) {
    _viewWidth = width;
    _viewHalfWidth = width / 2.0;
    _viewHeight = height;
    _viewHalfHeight = height / 2.0;
    viewRect = Rect.fromLTRB(-_viewHalfWidth, -viewHalfHeight, _viewHalfWidth, viewHalfHeight);
  }

  void setWorldSize(double width, double height) {
    gameWidth = width;
    gameHeight = height;
    worldBounds =
        Rect.fromLTRB(-gameWidth / 2.0, -gameHeight / 2.0, gameWidth / 2.0, gameHeight / 2.0);
  }

  @override
  String toString() {
    return 'Parameters{ viewWidth:$_viewWidth viewHeight:$_viewHeight gameWidth:$gameWidth gameHeight:$gameHeight }';
  }
}
