class DebugSystem {
  static final double targetFPS = 60.0;
  static final double showDebugInterval = 30;
  final String tag;
  final Stopwatch _updateWatch = Stopwatch();
  final Stopwatch _renderWatch = Stopwatch();
  final Stopwatch _renderTextWatch = Stopwatch();

  int frameCount = 0;
  double currentTime = 0;
  double nextDebugTime = 0;

  bool debugMode = false;

  DebugSystem({String tag = 'main'}) : tag = tag;

  void update(double deltaTime) {
    currentTime += deltaTime;
    if (currentTime > nextDebugTime && debugMode) {
      nextDebugTime = currentTime + showDebugInterval;
      printResult();
    }
    frameCount++;
  }

  void reset() {
    _updateWatch.reset();
    _renderWatch.reset();
    _renderTextWatch.reset();
  }

  void startUpdate() {
    _updateWatch.start();
  }

  void stopUpdate() {
    _updateWatch.stop();
  }

  void startRender() {
    _renderWatch.start();
  }

  void stopRender() {
    _renderWatch.stop();
  }

  void startTextLayout() {
    _renderTextWatch.start();
  }

  void stopTextLayout() {
    _renderTextWatch.stop();
  }

  int get updateMs => _updateWatch.elapsedMilliseconds;

  int get renderMs => _renderWatch.elapsedMilliseconds;

  int get textMs => _renderTextWatch.elapsedMilliseconds;

  void printResult() {
    print(
        'DebugSystem{[$tag] time:${currentTime.round()}(s) frame:$frameCount \n  update:$updateMs(ms) $updatePof% \n  render:$renderMs(ms) $renderPof% \n  textLayout:$textMs(ms) ${_pof(textMs)}%\n}');
  }

  double get updatePof => _pof(updateMs);

  double get renderPof => _pof(renderMs);

  double get textPof => _pof(textMs);

  // percentage of frame (ms/(1000/fps)*100)
  double _pof(int ms) {
    return ((ms / frameCount.toDouble()) / (10.0 / targetFPS)).floorToDouble();
  }
}
