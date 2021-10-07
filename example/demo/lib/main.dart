import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'src/example_benchmark.dart';
import 'src/example_flame.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(GameWidget(
    //game: ExampleFlame(),
    game: ExampleBenchmark(),
  ));
}
