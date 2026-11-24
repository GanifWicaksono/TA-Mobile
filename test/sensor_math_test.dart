import 'package:flutter_test/flutter_test.dart';
import 'package:carelink/core/utils/sensor_math.dart';

void main() {
  group('SensorMath Tests', () {
    test('calculateResultant correctly calculates 3D magnitude', () {
      final resultant = SensorMath.calculateResultant(3.0, 4.0, 0.0);
      expect(resultant, equals(5.0));

      final gravity3D = SensorMath.calculateResultant(0.0, 0.0, 9.8);
      expect(gravity3D, closeTo(9.8, 0.001));
    });

    test('calculateTiltAngleDegrees accurately measures vertical angle', () {
      final flatTilt = SensorMath.calculateTiltAngleDegrees(0.0, 0.0, 9.8);
      expect(flatTilt, closeTo(0.0, 0.1));

      final verticalTilt = SensorMath.calculateTiltAngleDegrees(9.8, 0.0, 0.0);
      expect(verticalTilt, closeTo(90.0, 0.1));
    });

    test('movingAverage smooths sequential values correctly', () {
      final values = [10.0, 12.0, 14.0, 16.0, 18.0];
      final avg = SensorMath.movingAverage(values);
      expect(avg, equals(14.0));
    });

    test('calculateVariance measures motionless vs active acceleration', () {
      final motionless = [9.79, 9.80, 9.81, 9.80, 9.79];
      final active = [2.0, 18.0, 5.0, 24.0, 1.0];

      final varMotionless = SensorMath.calculateVariance(motionless);
      final varActive = SensorMath.calculateVariance(active);

      expect(varMotionless, lessThan(0.01));
      expect(varActive, greaterThan(20.0));
    });
  });
}
