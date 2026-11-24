import 'dart:math';

class SensorMath {
  SensorMath._();

  static double calculateResultant(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
  }

  static double calculateTiltAngleDegrees(double x, double y, double z) {
    final magnitude = calculateResultant(x, y, z);
    if (magnitude == 0) return 0;
    final cosTheta = (z / magnitude).clamp(-1.0, 1.0);
    return acos(cosTheta) * (180.0 / pi);
  }

  static double movingAverage(List<double> values) {
    if (values.isEmpty) return 0;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  static double calculateVariance(List<double> values) {
    if (values.length < 2) return 0;
    final mean = movingAverage(values);
    final sumSquaredDiff = values.fold<double>(
      0.0,
      (prev, element) => prev + pow(element - mean, 2),
    );
    return sumSquaredDiff / values.length;
  }

  static double calculateStdDev(List<double> values) {
    return sqrt(calculateVariance(values));
  }
}
