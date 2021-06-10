import 'dart:ui';

class Parameters {
  late double _viewWidth;
  late double _viewHalfWidth;
  late double _viewHeight;
  late double _viewHalfHeight;

  double gameWidth;
  double gameHeight;
  final Rect worldBounds;

  Parameters(
      {double viewWidth = 0, double viewHeight = 0, this.gameWidth = 1000, this.gameHeight = 1000})
      : worldBounds =
            Rect.fromLTRB(-gameWidth / 2.0, -gameHeight / 2.0, gameWidth / 2.0, gameHeight / 2.0) {
    this.viewWidth = viewWidth;
    this.viewHeight = viewHeight;
  }

  double get viewWidth => _viewWidth;

  double get viewHalfWidth => _viewHalfWidth;

  double get viewHeight => _viewHeight;

  double get viewHalfHeight => _viewHalfHeight;

  set viewWidth(double width) {
    _viewWidth = width;
    _viewHalfWidth = width / 2.0;
  }

  set viewHeight(double height) {
    _viewHeight = height;
    _viewHalfHeight = height / 2.0;
  }

  @override
  String toString() {
    return 'Parameters{ viewWidth:$_viewWidth viewHeight:$_viewHeight gameWidth:$gameWidth gameHeight:$gameHeight }';
  }
}
