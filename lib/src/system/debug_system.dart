class DebugSystem {
  final String tag;
  int fpsCount = 0;
  int _frameCount = 0;
  double _currentTime = 0;

  DebugSystem({this.tag = 'main'});

  void update(double deltaTime) {
    _currentTime += deltaTime;
    _frameCount++;
    if (_currentTime >= 1.0) {
      _currentTime -= 1.0;
      fpsCount = _frameCount;
      _frameCount = 0;
    }
  }
}
