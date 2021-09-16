import 'dart:typed_data';
import 'dart:ui';

import '../../batch.dart';
import '../../components.dart';
import '../../core.dart';
import '../../graphics.dart';
import '../core/math.dart';
import 'registry.dart';
import 'text_system.dart';

class RenderSystem with Registry {
  static const int textureSortBucketSize = 1000;
  final PhasedObjectManager<PhasedObject> _renderQueue = PhasedObjectManager();
  final Batch _batch = EngineBatch();

  void draw(
      {required Drawable drawable,
      required Vector2 position,
      required int priority,
      bool cameraRelative = true}) {
    // DrawableObject
    if (drawable is DrawableObject) {
      drawObject(
          drawable: drawable,
          position: position,
          priority: priority,
          cameraRelative: cameraRelative);
    }
    // DrawableText
    else if (drawable is DrawableText) {
      systems.textSystem.drawText(
          drawable: drawable,
          position: position,
          priority: priority,
          cameraRelative: cameraRelative);
    }
    // DrawableObjectList
    else if (drawable is DrawableObjectList) {
      if (drawable.isNotReady) {
        return;
      }
      _renderQueue.add(RenderElement(
          priority: priority,
          data: drawable.data!,
          textureRegion: drawable.textureRegion!,
          color: drawable.color,
          length: drawable.length));
    } else {
      print('not supported element');
    }
  }

  void drawObject(
      {required DrawableObject drawable,
      required Vector2 position,
      required int priority,
      bool cameraRelative = true}) {
    if (drawable.hasTextureRegion) {
      drawTextureRegion(
          textureRegion: drawable.textureRegion!,
          data: drawable.data,
          color: drawable.color,
          position: position,
          priority: priority,
          cameraRelative: cameraRelative);
    }
  }

  void drawTextureRegion(
      {required TextureRegion textureRegion,
      required Float32List data,
      required Vector2 position,
      required int priority,
      int? color,
      bool cameraRelative = true}) {
    final elementData = data.sublist(0);
    if (cameraRelative) {
      final focusPosition = systems.cameraSystem.focusPosition;
      elementData[2] += position.x - focusPosition.x + parameters.viewHalfWidth;
      elementData[3] += position.y - focusPosition.y + parameters.viewHalfHeight;
    } else {
      elementData[2] += position.x;
      elementData[3] += position.y;
    }
    _renderQueue.add(RenderElement(
        priority: priority, data: elementData, textureRegion: textureRegion, color: color));
  }

  void drawTextElement(TextElement textElement) {
    _renderQueue.add(textElement);
  }

  void _draw(Canvas canvas) {
    _batch.beginBatch(canvas);
    var objects = _renderQueue.getObjects().list;
    for (var element in objects) {
      if (element is RenderElement) {
        _batch.drawRenderElement(element);
      } else if (element is TextElement) {
        //TODO
        _batch.endBatch();
        element.paint(canvas);
        _batch.beginBatch(canvas);
      }
    }
    _batch.endBatch();
  }

  void render(Canvas canvas) {
    systems.debugSystem.startRender();
    _renderQueue.commitUpdates();
    _draw(canvas);
    _renderQueue.reset();
    systems.debugSystem.stopRender();
  }

  @override
  String toString() {
    return '[RenderSystem]';
  }
}

class RenderElement extends PhasedObject {
  final Float32List data;
  final TextureRegion textureRegion;
  final int? color;
  final int length;

  RenderElement(
      {required int priority,
      required this.data,
      required this.textureRegion,
      this.color,
      this.length = 1})
      : super(phase: _getRenderPhase(priority, textureRegion.texture));

  @override
  void reset() {}

  bool get single => length == 1;

  @override
  String toString() {
    return '\nRenderElement{ phase:$phase data:$data $textureRegion color:$color [$hashCode]}';
  }
}

int _getRenderPhase(int priority, Texture texture) {
  return priority * RenderSystem.textureSortBucketSize + texture.sortIndex;
}
