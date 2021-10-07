import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';
import 'game_renderer_box.dart';

class GameWidget extends LeafRenderObjectWidget {
  final Game game;

  const GameWidget({required this.game, Key? key}) : super(key: key);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: GameRenderBox(context, game), additionalConstraints: const BoxConstraints.expand());
  }

  @override
  void updateRenderObject(BuildContext context, RenderConstrainedBox renderObject) {
    renderObject
      ..child = GameRenderBox(context, game)
      ..additionalConstraints = const BoxConstraints.expand();
  }
}
