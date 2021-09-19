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
        element.setRaw(
            priority: priority,
            data: drawable.data!,
            textureRegion: drawable.textureRegion!,
            color: drawable.color);
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
    var element = elementPool.allocate();
    if (element != null) {
      element.setSingle(priority: priority, data: data, textureRegion: textureRegion, color: color);
      if (cameraRelative) {
        final focusPosition = systems.cameraSystem.focusPosition;
        var x = position.x - focusPosition.x + parameters.viewHalfWidth;
        var y = position.y - focusPosition.y + parameters.viewHalfHeight;
        element.move(x, y);
      } else {
        element.move(position.x, position.y);
      }
      _renderQueue.add(element);
    }
  }

  void drawTextElement(TextElement textElement) {
    _renderQueue.add(textElement);
  }

  void _draw(Canvas canvas) {
    _batch.beginBatch(canvas);
    var objects = _renderQueue.getObjects().data;
    for (var element in objects) {
      if (element is RenderElement) {
        var textureRegion = element.textureRegion!;
        if (element.isSingle) {
          _batch.drawTextureRegion(textureRegion, element.single, element.color);
        } else {
          _batch.drawImages(textureRegion.image, element.raw!, textureRegion.rawRect, element.color);
        }
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
    var objects = _renderQueue.getObjects().data;
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
  Float32List single = Float32List(4);
  Float32List? raw;
  TextureRegion? textureRegion;
  int? color;

  RenderElement._();

  void setSingle(
      {required int priority,
      required Float32List data,
      required TextureRegion textureRegion,
      int? color}) {
    phase = _getRenderPhase(priority, textureRegion.texture.sortIndex);
    single.setAll(0, data);
    raw = null;
    this.textureRegion = textureRegion;
    this.color = color;
  }

  void setRaw(
      {required int priority,
      required Float32List data,
      required TextureRegion textureRegion,
      int? color}) {
    phase = _getRenderPhase(priority, textureRegion.texture.sortIndex);
    raw = data;
    this.textureRegion = textureRegion;
    this.color = color;
  }

  void move(double dx, double dy) {
    single[2] += dx;
    single[3] += dy;
  }

  @override
  void reset() {
    raw = null;
    textureRegion = null;
    color = null;
  }

  bool get isSingle => raw == null;

  int get length => (raw == null) ? 0 : raw!.length ~/ 4;

  @override
  String toString() {
    return 'RenderElement{ phase:$phase data:$single $textureRegion color:$color [$hashCode]}';
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
