import 'package:composition_rendering/engine.dart';

import 'components/focusing_component.dart';
import 'game_factory.dart';

class DemoScene extends Scene with Factory {
  late SceneObject player1, player2;

  @override
  void init() {
    add(gameFactory.spawnBackground());
    add(player1 = gameFactory.spawnPlayer('p2.png', 0.5)
      ..position.setValues(-100, -100));
    add(player2 = gameFactory.spawnPlayer('p1.png', -1.1)
      ..position.setValues(100, 100));
    // Tracking the camera for players at a specified interval
    add(SceneObject()
      ..add(FocusingComponent(
          targets: [player1, player2],
          startTime: 2,
          interval: 4.5,
          looping: true)));
  }
}
