import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'game_loop.dart';

abstract class GameUpdater {
  void onUpdate(double deltaTime);

  void lifecycleStateChange(AppLifecycleState state);
}

abstract class GameRenderer {
  bool get isAttached;

  void onAttach();

  void onDetach();

  void render(Canvas canvas, Offset offset);

  void resize(double width, double height);

  void Function()? markNeedsPaint;
}

abstract class Game implements GameRenderer, GameUpdater {
  late final GameLoop updater;

  bool initialized = false;
  bool _attached = false;

  Game() {
    updater = GameLoop(this);
  }

  void init();

  @override
  bool get isAttached => _attached;

  @override
  void onAttach() {
    _attached = true;
    if (!initialized) {
      init();
      initialized = true;
    }
    updater.onAttach();
  }

  @override
  void onUpdate(double deltaTime) {
    if (!isAttached) {
      return;
    }
    update(deltaTime);
    markNeedsPaint!.call();
  }

  void update(double deltaTime);

  @override
  void onDetach() {
    updater.onDetach();
    _attached = false;
  }

  @override
  void Function()? markNeedsPaint;
}

abstract class BaseGame extends Game {
  @override
  void resize(double width, double height) {}

  @override
  void lifecycleStateChange(AppLifecycleState state) {}
}
