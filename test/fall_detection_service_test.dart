import 'package:flutter_test/flutter_test.dart';
import 'package:carelink/core/services/fall_detection_service.dart';
import 'package:carelink/app/constants/fall_detection_config.dart';

void main() {
  group('FallDetectionService State Machine Tests', () {
    test('Initial state is idle', () {
      final service = FallDetectionService();
      expect(service.state, equals(FallDetectionState.idle));
    });

    test('State transitions from idle to monitoring', () {
      final service = FallDetectionService();
      service.startMonitoring();
      expect(service.state, equals(FallDetectionState.monitoring));
      service.stopMonitoring();
      expect(service.state, equals(FallDetectionState.idle));
    });

    test('Simulate fall triggers possibleFall state and callback', () {
      final service = FallDetectionService();
      bool callbackFired = false;
      service.onPossibleFallDetected = () {
        callbackFired = true;
      };

      service.simulateFallEvent();

      expect(service.state, equals(FallDetectionState.possibleFall));
      expect(callbackFired, isTrue);
    });

    test('Confirmation transitions correctly to safe vs emergency', () {
      final service = FallDetectionService();
      service.simulateFallEvent();
      service.enterConfirmation();
      expect(service.state, equals(FallDetectionState.confirmation));

      service.confirmEmergency();
      expect(service.state, equals(FallDetectionState.emergencyTriggered));
    });
  });
}
