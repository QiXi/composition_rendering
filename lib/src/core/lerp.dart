import 'math.dart';

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

  static double lerpRadians(double start, double target, double duration, double timeSinceStart) {
    double result;
    final range = target - start;
    if (range < -pi) {
      target += twoPi;
      result = lerp(start, target, duration, timeSinceStart);
      if (result >= twoPi) {
        result -= twoPi;
      }
    } else if (range > pi) {
      target -= twoPi;
      result = lerp(start, target, duration, timeSinceStart);
      if (result < 0) {
        result += twoPi;
      }
    } else {
      result = lerp(start, target, duration, timeSinceStart);
    }
    return result;
  }

  static double lerpDegrees(double start, double target, double duration, double timeSinceStart) {
    double result;
    final range = target - start;
    if (range < -180) {
      target += 360;
      result = lerp(start, target, duration, timeSinceStart);
      if (result >= 360) {
        result -= 360;
      }
    } else if (range > 180) {
      target -= 360;
      result = lerp(start, target, duration, timeSinceStart);
      if (result < 0) {
        result += 360;
      }
    } else {
      result = lerp(start, target, duration, timeSinceStart);
    }
    return result;
  }
}
