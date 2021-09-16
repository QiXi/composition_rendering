class AnimationSequence {
  String name;

  List<int> frames;

  int frameRate;

  bool loop;

  AnimationSequence(
      {required this.name, required this.frames, required this.frameRate, required this.loop});

  @override
  String toString() {
    return 'AnimationSequence{ "$name" loop:$loop $frames}';
  }
}
