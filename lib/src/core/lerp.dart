import 'fast_math.dart';

class Lerp {
  static double lerp(double start, double target, double duration, double timeSinceStart) {
    if (timeSinceStart > 0 && timeSinceStart < duration) {
      final range = target - start;
      final percent = timeSinceStart / duration;
      return start + (range * percent);
    } else if (timeSinceStart >= duration) {
      return target;
    }
    return start;
  }

  static double ease(double start, double target, double duration, double timeSinceStart) {
    if (timeSinceStart > 0 && timeSinceStart < duration) {
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

  static double lerpRadians(double start, double target, double duration, double timeSinceStart) {
    final range = target - start;
    if (range < -pi) {
      var result = lerp(start, target + twoPi, duration, timeSinceStart);
      return (result >= twoPi) ? result - twoPi : result;
    } else if (range > pi) {
      var result = lerp(start, target - twoPi, duration, timeSinceStart);
      return (result < 0) ? result + twoPi : result;
    }
    return lerp(start, target, duration, timeSinceStart);
  }

  static double lerpDegrees(double start, double target, double duration, double timeSinceStart) {
    final range = target - start;
    if (range < -180) {
      var result = lerp(start, target + 360, duration, timeSinceStart);
      return (result >= 360) ? result - 360 : result;
    } else if (range > 180) {
      var result = lerp(start, target - 360, duration, timeSinceStart);
      return (result < 0) ? result + 360 : result;
    }
    return lerp(start, target, duration, timeSinceStart);
  }
}
