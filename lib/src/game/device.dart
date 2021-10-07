import 'package:flutter/services.dart';

Future<void> fullScreen() {
  return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

Future<void> setLandscape() {
  return SystemChrome.setPreferredOrientations((<DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]));
}
