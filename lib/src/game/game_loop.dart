import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';

class GameLoop extends WidgetsBindingObserver {
  final GameUpdater updater;
  int _frameCallbackId = -1;
  Duration _previous = Duration.zero;

  GameLoop(this.updater);

  void onAttach() {
    _scheduleTick();
    _bindLifecycleListener();
  }

  void onDetach() {
    _unscheduleTick();
    _unbindLifecycleListener();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance?.scheduleFrameCallback(_tick) ?? -1;
  }

  void _unscheduleTick() {
    if (_frameCallbackId != -1) {
      SchedulerBinding.instance?.cancelFrameCallbackWithId(_frameCallbackId);
    }
  }

  void _tick(Duration timestamp) {
    final double deltaTime = _computeDelta(timestamp);
    updater.onUpdate(deltaTime);
    _scheduleTick();
  }

  double _computeDelta(Duration now) {
    Duration delta = now - _previous;
    if (_previous == Duration.zero) {
      delta = Duration.zero;
    }
    _previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    updater.lifecycleStateChange(state);
  }
}
