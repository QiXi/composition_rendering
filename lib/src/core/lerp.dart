class Lerp {
  static double lerp(double start, double target, double duration, double timeSinceStart) {
    if (timeSinceStart > 0.0 && timeSinceStart < duration) {
      final range = target - start;
      final percent = timeSinceStart / duration;
      return start + (range * percent);
    } else if (timeSinceStart >= duration) {
      return target;
    }
    return start;
  }

  static double ease(double start, double target, double duration, double timeSinceStart) {
    if (timeSinceStart > 0.0 && timeSinceStart < duration) {
      final range = target - start;
      final percent = timeSinceStart / (duration / 2.0);
      if (percent < 1.0) {
        return start + ((range / 2.0) * percent * percent * percent);
      } else {
        final shiftedPercent = percent - 2.0;
        return start + ((range / 2.0) * ((shiftedPercent * shiftedPercent * shiftedPercent) + 2.0));
      }
    } else if (timeSinceStart >= duration) {
      return target;
    }
    return start;
  }
}
