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
  final Batch _batch = EngineBatch();
  final RenderQueue _renderQueue = RenderQueue(256);

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
      _renderQueue.allocate().setRaw(
          priority: priority,
          data: drawable.data!,
          textureRegion: drawable.textureRegion!,
          color: drawable.color);
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
          transform: drawable.data,
          color: drawable.color,
          position: position,
          priority: priority,
          cameraRelative: cameraRelative);
    }
  }

  void drawTextureRegion(
      {required TextureRegion textureRegion,
      required TransformData transform,
      required Vector2 position,
      required int priority,
      int? color,
      bool cameraRelative = true}) {
    var dx, dy;
    if (cameraRelative) {
      final focusPosition = systems.cameraSystem.focusPosition;
      dx = position.x - focusPosition.x + parameters.viewHalfWidth;
      dy = position.y - focusPosition.y + parameters.viewHalfHeight;
    } else {
      dx = position.x;
      dy = position.y;
    }
    _renderQueue.allocate().setSingle(
        priority: priority,
        data: transform,
        textureRegion: textureRegion,
        color: color,
        dx: dx,
        dy: dy);
  }

  void drawTextElement(TextElement element) {
    _renderQueue.allocate().setText(element);
  }

  void _draw(Canvas canvas) {
    _batch.beginBatch(canvas);
    var objects = _renderQueue.data;
    final length = _renderQueue.data.length;
    for (int i = 0; i < length; i++) {
      var element = objects[i];
      if (!element.empty) {
        if (element.textElement != null) {
          //TODO
          _batch.endBatch();
          element.textElement!.paint(canvas);
          _batch.beginBatch(canvas);
        } else if (element.textureRegion != null) {
          var textureRegion = element.textureRegion!;
          if (element.isSingle) {
            _batch.drawTextureRegion(textureRegion, element.single, element.color);
          } else {
            _batch.drawImages(
                textureRegion.image, element.raw!, textureRegion.rawRect, element.color);
          }
        }
      }
    }
    _batch.endBatch();
  }

  void render(Canvas canvas) {
    systems.debugSystem.startRender();
    _renderQueue.commitUpdates();
    _draw(canvas);
    _renderQueue.releaseAll();
    systems.debugSystem.stopRender();
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
  TextElement? textElement;
  bool empty = true;

  RenderElement._();

  @override
  void reset() {
    raw = null;
    textureRegion = null;
    color = null;
    textElement = null;
  }

  bool get isSingle => raw == null;

  int get length => (raw == null) ? 0 : raw!.length ~/ 4;

  void setSingle(
      {required int priority,
      required TransformData data,
      required TextureRegion textureRegion,
      int? color,
      double dx = 0,
      double dy = 0}) {
    reset();
    phase = _getRenderPhase(priority, textureRegion.texture.sortIndex);
    single[0] = data.scos;
    single[1] = data.ssin;
    single[2] = data.tx + dx;
    single[3] = data.ty + dy;
    this.textureRegion = textureRegion;
    this.color = color;
    empty = false;
  }

  void setRaw(
      {required int priority,
      required Float32List data,
      required TextureRegion textureRegion,
      int? color}) {
    reset();
    phase = _getRenderPhase(priority, textureRegion.texture.sortIndex);
    raw = data;
    this.textureRegion = textureRegion;
    this.color = color;
    empty = false;
  }

  void setText(TextElement element) {
    reset();
    phase = element.phase;
    textElement = element;
    empty = false;
  }

  @override
  String toString() {
    return 'RenderElement{ phase:$phase data:$single $textureRegion color:$color [$hashCode]}';
  }
}

int _getRenderPhase(int priority, int sortIndex) {
  return priority * RenderSystem.textureSortBucketSize + sortIndex;
}

class RenderQueue {
  int _size;
  int _lastIndex = 0;
  final List<RenderElement> data;

  RenderQueue(this._size)
      : data = List.generate(_size, (int index) => RenderElement._(), growable: true);

  RenderElement allocate() {
    if (_lastIndex >= _size) {
      data.addAll(List.generate(_size, (int index) => RenderElement._(), growable: false));
      _size = data.length;
    }
    var item = data[_lastIndex];
    _lastIndex++;
    return item;
  }

  int get count => _lastIndex;

  void commitUpdates() {
    resetLast();
    data.sort(_compare);
  }

  void resetLast() {
    var objects = data;
    for (int i = _lastIndex; i < _size; i++) {
      var element = objects[i];
      element.empty = true;
    }
  }

  void releaseAll() {
    _lastIndex = 0;
  }

  int _compare(RenderElement obj1, RenderElement obj2) {
    return (obj1.phase - obj2.phase);
  }
}
