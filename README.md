<p align="center">
<a title="Pub" href="https://pub.dartlang.org/packages/composition_rendering" ><img alt="Pub Version" src="https://img.shields.io/pub/v/composition_rendering?color=blue&style=for-the-badge"></a>
</p>

A tool for creating objects based on composition and painting on canvas. It can be used in the base of the game engine.

Drawing is based on [Canvas.drawRawAtlas](https://api.flutter.dev/flutter/dart-ui/Canvas/drawRawAtlas.html)

## Demo
[![example scene](https://img.youtube.com/vi/s7eeh_UWTsI/0.jpg)](https://www.youtube.com/watch?v=s7eeh_UWTsI)


## Usage

A simple usage example:

```dart
import 'package:composition_rendering/core.dart';
import 'package:composition_rendering/scene.dart';

void main() {
  final gameScene = GameScene();
}

class GameScene extends Scene {
  @override
  void init() {
    var texture = systems.textureSystem.getTextureRegion('bg.jpg');
    var background = systems.factorySystem.spawnSprite(texture!, Priority.background);
    add(background);
  }
}
```


## Use with Flame

Plugin for integrating composition rendering into the Flame game engine. <a title="Pub" href="https://pub.dartlang.org/packages/flame_composition_rendering" ><img alt="Pub Version" src="https://img.shields.io/pub/v/flame_composition_rendering?label=flame_composition_rendering&style=for-the-badge"></a>

## History of creation

The source of inspiration was the resource [Replica Island](https://code.google.com/archive/p/replicaisland/)

Other projects that may have influenced the development of this work:
 - [libGDX](https://libgdx.com/)
 - [Fluttershy](https://github.com/DavidDomkar/fluttershy)
 - [Flame](https://flame-engine.org/)

