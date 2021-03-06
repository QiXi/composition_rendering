import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:composition_rendering/batch.dart';
import 'package:composition_rendering/src/core/fast_math.dart';
import 'package:test/test.dart';

void main() {
  const defaultColor = 0xffffffff;
  test('EngineBatch.drawImage', () async {
    final image = await _createImage(1, 1);
    final bath = EngineBatch(capacity: 2);
    bath.drawImageFromData(image, const Rect.fromLTWH(0, 0, 1, 1), 1, 0, 0, 0, defaultColor);
    expect(bath.rectCount, 1);
    expect(bath.freeLength, 4);
    var rawSprite = Float32List.fromList([1, 0, 10, 10, 1, 0, 20, 20, 1, 0, 30, 30]);
    var rawRect = Float32List.fromList([1, 2, 3, 4, 10, 20, 30, 40, 100, 200, 300, 400]);
    bath.drawImages(image, rawSprite, rawRect, defaultColor);
    expect(bath.rectCount, 2);
    expect(bath.freeLength, 0);
  });

  test('FastMath', () async {
    var radians = -twoPi;
    while (radians < twoPi) {
      var round = radRound(radians);
      var fSin = fastSin(round);
      var diff = fSin - sin(round);
      // var d = round * 180 / pi;
      // print('${d.roundToDouble()} $fSin ${sin(round)} diff:$diff (${(diff * 180 / pi)})');
      expect(diff < 0.057, true);// max 3.2 deg
      radians += 0.05;
    }
  });
}

Future<ui.Image> _createImage(int width, int height) async {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    Uint8List.fromList(List<int>.filled(width * height * 4, 0, growable: false)),
    width,
    height,
    ui.PixelFormat.rgba8888,
    (ui.Image image) {
      completer.complete(image);
    },
  );
  return completer.future;
}
