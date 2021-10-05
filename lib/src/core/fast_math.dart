import 'dart:math';

export 'dart:math';

const double halfPi = pi / 2;
const double twoPi = pi * 2;

double radRound(double x) {
  if (x < -pi) {
    return x += twoPi;
  } else if (x > pi) {
    return x -= twoPi;
  }
  return x;
}

fastSin(double x) {
  if (x < 0) {
    return 1.27323954 * x + 0.405284735 * x * x;
  } else {
    return 1.27323954 * x - 0.405284735 * x * x;
  }
}

fastCos(double x) {
  x += halfPi;
  if (x > pi) {
    x -= twoPi;
  }
  if (x < 0) {
    return 1.27323954 * x + 0.405284735 * x * x;
  } else {
    return 1.27323954 * x - 0.405284735 * x * x;
  }
}
