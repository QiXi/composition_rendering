import 'dart:collection';
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
  final RenderElementPool elementPool = RenderElementPool(512);

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
      var element = elementPool.allocate();
      if (element != null) {
        element.set(
            priority: priority,
            data: drawable.data!,
            textureRegion: drawable.textureRegion!,
            color: drawable.color,
            length: drawable.length);
        _renderQueue.add(element);
      }
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
    var element = elementPool.allocate();
    if (element != null) {
      element.set(
          priority: priority,
          data: elementData,
          textureRegion: textureRegion,
          color: color,
          length: 1);
      _renderQueue.add(element);
    }
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
    clearQueue();
    systems.debugSystem.stopRender();
  }

  void clearQueue() {
    var objects = _renderQueue.getObjects().list;
    for (int i = objects.length - 1; i >= 0; i--) {
      var element = objects[i];
      if (element is RenderElement) {
        elementPool.release(element);
      }
    }
    _renderQueue.reset();
  }

  @override
  String toString() {
    return '[RenderSystem]';
  }
}

class RenderElement extends PhasedObject {
  Float32List? data;
  TextureRegion? textureRegion;
  int? color;
  int length = 1;

  RenderElement._();

  set(
      {required int priority,
      required Float32List data,
      required TextureRegion textureRegion,
      int? color,
      required int length}) {
    phase = _getRenderPhase(priority, textureRegion.texture.sortIndex);
    this.data = data;
    this.textureRegion = textureRegion;
    this.color = color;
    this.length = length;
  }

  @override
  void reset() {
    data = null;
    textureRegion = null;
    color = null;
    length = 1;
  }

  bool get single => length == 1;

  @override
  String toString() {
    return 'RenderElement{ phase:$phase data:$data $textureRegion color:$color [$hashCode]}';
  }
}

int _getRenderPhase(int priority, int sortIndex) {
  return priority * RenderSystem.textureSortBucketSize + sortIndex;
}

class RenderElementPool extends ObjectPool<RenderElement> {
  RenderElementPool(int max) : super(max);

  @override
  void release(RenderElement entry) {
    super.release(entry);
  }

  @override
  void fill(Queue<RenderElement> data) {
    for (int i = 0; i < size; i++) {
      data.add(RenderElement._());
    }
  }
}
