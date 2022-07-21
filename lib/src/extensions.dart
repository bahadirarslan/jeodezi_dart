import 'dart:math';

extension RadianMethods on double {
  double toDegrees() => this * 180 / pi;

  double toRadians() => this * pi / 180;

  double wrap360() {
    if (0 <= this && this < 360) {
      return this;
    }
    return (this % 360 + 360) % 360;
  }

  double wrap180() {
    if (0 <= this && this < 180) {
      return this;
    }
    return (this + 540) % 360 - 180;
  }
}
