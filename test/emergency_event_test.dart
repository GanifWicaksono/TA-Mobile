import 'package:flutter_test/flutter_test.dart';
import 'package:carelink/core/models/emergency_event_model.dart';

void main() {
  group('EmergencyEvent Model Tests', () {
    test('Serialization and deserialization work without loss', () {
      final now = DateTime.now();
      final original = EmergencyEvent(
        eventId: 'EVT-TEST-123',
        userId: 'user_1',
        userName: 'Bpk. Sutrisno',
        caregiverId: 'caregiver_1',
        eventType: EmergencyEventType.possibleFall,
        timestamp: now,
        latitude: -6.2088,
        longitude: 106.8456,
        locationAvailable: true,
        address: 'Jakarta, Indonesia',
        eventStatus: EmergencyEventStatus.received,
      );

      final json = original.toJson();
      final deserialized = EmergencyEvent.fromJson(json);

      expect(deserialized.eventId, equals('EVT-TEST-123'));
      expect(deserialized.userId, equals('user_1'));
      expect(deserialized.userName, equals('Bpk. Sutrisno'));
      expect(deserialized.eventType, equals(EmergencyEventType.possibleFall));
      expect(deserialized.latitude, equals(-6.2088));
      expect(deserialized.longitude, equals(106.8456));
      expect(deserialized.locationAvailable, isTrue);
      expect(deserialized.eventStatus, equals(EmergencyEventStatus.received));
    });

    test('copyWith updates status and handling notes correctly', () {
      final original = EmergencyEvent(
        eventId: 'EVT-001',
        userId: 'u1',
        userName: 'User 1',
        caregiverId: 'c1',
        eventType: EmergencyEventType.manualSos,
        timestamp: DateTime.now(),
        locationAvailable: false,
        eventStatus: EmergencyEventStatus.pending,
      );

      final updated = original.copyWith(
        eventStatus: EmergencyEventStatus.handled,
        handledNotes: 'Sudah ditangani langsung.',
      );

      expect(updated.eventStatus, equals(EmergencyEventStatus.handled));
      expect(updated.handledNotes, equals('Sudah ditangani langsung.'));
      expect(updated.eventId, equals('EVT-001'));
    });
  });
}
