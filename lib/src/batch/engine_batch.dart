import 'dart:typed_data';
import 'dart:ui';

import '../../graphics.dart';
import '../core/fast_math.dart';
import '../graphics/texture_region.dart';
import 'batch.dart';
import 'batch_data.dart';

class EngineBatch extends Batch {
  static const int defaultColor = 0xffffffff;

  final Paint defaultPaint;
  final BlendMode defaultBlendMode;
  final BatchData _batchData;

  int capacity;
  Canvas? _canvas;
  Image? _image;
  Rect? _cullRect;

  EngineBatch({this.capacity = 100, BlendMode? blendMode, Paint? paint})
      : defaultBlendMode = blendMode ?? BlendMode.srcIn,
        defaultPaint = paint ?? Paint()
          ..filterQuality = FilterQuality.low,
        _batchData = BatchData(capacity);

  int get rectCount => _batchData.rectCount;

  int get freeLength => _batchData.freeLength;

  @override
  void beginBatch(Canvas canvas, {Rect? cullRect}) {
    _canvas = canvas;
    _cullRect = cullRect;
  }

  @override
  void drawTextureRegion(TextureRegion textureRegion, Float32List data, int? color) {
    drawImage(textureRegion.image, data, textureRegion.rawRect, color ?? defaultColor);
  }

  @override
  void drawTextureRegionFromData(
      TextureRegion textureRegion, double scos, double ssin, double tx, double ty, int? color) {
    drawImageFromData(textureRegion.texture.image, textureRegion.rect, scos, ssin, tx, ty, color);
  }

  @override
  void drawImageFromData(
      Image image, Rect rect, double scos, double ssin, double tx, double ty, int? color) {
    _checkFlush(image);
    _image = image;
    _batchData.fillFromTransform(scos, ssin, tx, ty, rect, color ?? defaultColor);
  }

  @override
  void drawImage(Image image, Float32List data, Float32List rect, int? color) {
    _checkFlush(image);
    _image = image;
    _batchData.fillOneUnit(data, rect, color ?? defaultColor);
  }

  @override
  void drawImages(Image image, Float32List data, Float32List rect, int? color,
      [int skipCount = 0]) {
    _checkFlush(image);
    _image = image;
    final overflow = (data.length - skipCount) - _batchData.freeLength;
    if (overflow > 0) {
      final skipLength = skipCount + _batchData.freeLength;
      _batchData.fillFromRawData(data, rect, color ?? defaultColor);
      drawImages(image, data, rect, color, skipLength);
    } else {
      _batchData.fillFromRawData(data, rect, color ?? defaultColor, skipCount);
    }
  }

  void _checkFlush(Image image) {
    if (_image != image || _batchData.rectCount >= capacity) {
      _flush(_canvas);
    }
  }

  @override
  void drawImageFromComponents(
      {required Image image,
      required Rect rect,
      required double rotation,
      required double scale,
      required double anchorX,
      required double anchorY,
      required double translateX,
      required double translateY,
      int? color}) {
    _checkFlush(image);
    var round = radRound(rotation);
    final scos = fastCos(rotation) * scale;
    final ssin = fastSin(rotation) * scale;
    final tx = translateX + -scos * anchorX + ssin * anchorY;
    final ty = translateY + -ssin * anchorX - scos * anchorY;
    _image = image;
    _batchData.fillFromTransform(scos, ssin, tx, ty, rect, color ?? defaultColor);
  }

  @override
  void endBatch() {
    _flush(_canvas);
  }

  void _flush(Canvas? canvas) {
    if (_image != null && canvas != null) {
      _batchData.fillToEnd();
      canvas.drawRawAtlas(_image!, _batchData.rawTransforms, _batchData.rawSources,
          _batchData.rawColors, defaultBlendMode, _cullRect, defaultPaint);
      _batchData.reset();
    }
  }
}
