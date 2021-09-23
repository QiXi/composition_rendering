import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

class BatchData {
  final Float32List rawTransforms;
  final Float32List rawSources;
  final Int32List rawColors;
  int _rectCount = 0;

  BatchData(int max)
      : rawTransforms = Float32List(max * 4),
        rawSources = Float32List(max * 4),
        rawColors = Int32List(max * 1);

  void reset() {
    _rectCount = 0;
  }

  int get rectCount => _rectCount;

  int get currentIndex => _rectCount * 4;

  int get freeLength => rawTransforms.length - currentIndex;

  int get freeCount => freeLength % 4;

  void fillToEnd() {
    rawSources.fillRange(currentIndex, rawSources.length, 0);
  }

  void fillOneUnit(Float32List rstTransforms, Float32List rect, int color, [int skipCount = 0]) {
    //TODO performance
    final index0 = currentIndex;
    rawTransforms.setRange(index0, index0 + 4, rstTransforms, skipCount);
    rawSources.setRange(index0, index0 + 4, rect, skipCount);
    rawColors[_rectCount] = color;
    _rectCount++;
  }

  void fillFromRawData(Float32List rstTransforms, Float32List rect, int color,
      [int skipCount = 0]) {
    final fillLength = max(0, min(freeLength, rstTransforms.length - skipCount));
    if (fillLength < 4) {
      print('error fillLength:$fillLength must be at least 4');
      return;
    }
    final index0 = currentIndex;
    final end = index0 + fillLength;
    rawTransforms.setRange(index0, end, rstTransforms, skipCount);
    final fillCount = fillLength ~/ 4;
    for (var i = 0; i < fillCount; i++) {
      var start = i * 4;
      rawSources.setRange(index0 + start, start + 4, rect, skipCount);
    }
    rawColors.fillRange(_rectCount, _rectCount + fillCount, color);
    _rectCount += fillCount;
  }

  void fillFromTransform(double scos, double ssin, double tx, double ty, Rect rect, int color) {
    final index0 = currentIndex;
    final index1 = index0 + 1;
    final index2 = index0 + 2;
    final index3 = index0 + 3;
    //
    rawTransforms[index0] = scos;
    rawTransforms[index1] = ssin;
    rawTransforms[index2] = tx;
    rawTransforms[index3] = ty;
    //
    rawSources[index0] = rect.left;
    rawSources[index1] = rect.top;
    rawSources[index2] = rect.right;
    rawSources[index3] = rect.bottom;
    //
    rawColors[_rectCount] = color;
    _rectCount++;
  }

  void fillFromRSTransform(RSTransform transform, Rect rect, int color) {
    fillFromTransform(transform.scos, transform.ssin, transform.tx, transform.ty, rect, color);
  }
}
