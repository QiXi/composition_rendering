import 'package:flutter/cupertino.dart' show Rect;

import '../../graphics.dart';
import 'animation_sequence.dart';

class AnimationData {
  static const int defaultFrameRate = 60;
  final Map<String, AnimationSequence> _animations = {};
  final Map<String, List<TextureRegion>> _regions = {};

  AnimationData();

  void reset() {
    _animations.clear();
    _regions.clear();
  }

  int get length => _animations.length;

  bool isContains(String name) => _animations.containsKey(name);

  void addAnimation(String name, List<TextureRegion> regions,
      [bool loop = false, int frameRate = defaultFrameRate]) {
    addAnimationRange(name, regions, 0, regions.length, loop, frameRate);
  }

  void addAnimationRange(String name, List<TextureRegion> regions, int frameBegin, int frameEnd,
      [bool loop = false, int frameRate = defaultFrameRate]) {
    if (frameBegin <= 0 || frameEnd <= 0) return;
    int length = (frameEnd - frameBegin);
    if (length > 0) {
      List<int> frames = [length];
      for (int i = 0; i < length; i++) {
        frames[i] = frameBegin + i;
      }
      AnimationSequence animation =
          AnimationSequence(name: name, frames: frames, frameRate: frameRate, loop: loop);
      _addAnimation(name, animation, regions.sublist(frameBegin, frameEnd));
    }
  }

  void addAnimationFromTexture(String name, Texture texture, double tileW, double tileH,
      [bool loop = false, int frameRate = defaultFrameRate]) {
    var width = texture.size.x;
    var height = texture.size.y;
    var row = (width / tileW).ceil();
    var col = (height / tileH).ceil();
    int length = row * col;
    if (length > 0) {
      List<TextureRegion> regions = [];
      List<int> frames = [];
      var index = 0;
      for (int j = 0; j < col; j++) {
        for (int i = 0; i < row; i++) {
          frames.add(index);
          var rect = Rect.fromLTWH(i * tileW, j * tileH, tileW, tileH);
          regions.add(TextureRegion(texture, regionRect: rect));
          index++;
        }
      }
      AnimationSequence animation =
          AnimationSequence(name: name, frames: frames, frameRate: frameRate, loop: loop);
      _addAnimation(name, animation, regions);
    }
  }

  void _addAnimation(
    String name,
    AnimationSequence animation,
    List<TextureRegion> regions,
  ) {
    _animations[name] = animation;
    _regions[name] = regions;
  }

  AnimationSequence? getAnimationSequence(String name) => _animations[name];

  TextureRegion? getTextureRegion(String name, int frame) {
    return _regions[name]?[frame];
  }

  @override
  String toString() {
    return _animations.values.toString();
  }
}
