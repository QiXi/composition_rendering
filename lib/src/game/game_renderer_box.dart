import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';

class GameRenderBox extends RenderBox {
  final BuildContext buildContext;
  final GameRenderer renderer;

  GameRenderBox(this.buildContext, this.renderer) {
    renderer.markNeedsPaint = markNeedsPaint;
  }

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    super.performResize();
    renderer.resize(constraints.constrainWidth(), constraints.constrainHeight());
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    renderer.onAttach();
  }

  @override
  void detach() {
    renderer.onDetach();
    super.detach();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    renderer.render(context.canvas, offset);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;
}
