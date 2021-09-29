import 'package:demo/src/example_benchmark.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'src/example_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(
    GameWidget(
      //game: ExampleLauncher(),
      game: ExampleBenchmark(),
    ),
  );
}
