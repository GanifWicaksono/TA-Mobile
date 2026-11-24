import 'package:uuid/uuid.dart';
import '../../core/models/emergency_event_model.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/notification_service.dart';

class EmergencyRepository {
  final StorageService _storageService;
  final NotificationService _notificationService = NotificationService();
  final _uuid = const Uuid();

  List<EmergencyEvent> _cachedEvents = [];

  EmergencyRepository(this._storageService) {
    _initEvents();
  }

  void _initEvents() {
    final stored = _storageService.getEvents();
    if (stored.isNotEmpty) {
      _cachedEvents = stored;
    } else {
      _cachedEvents = _generateDemoEvents();
      _storageService.saveEvents(_cachedEvents);
    }
  }

  List<EmergencyEvent> _generateDemoEvents() {
    final now = DateTime.now();
    return [
      EmergencyEvent(
        eventId: 'EVT-DEMO-001',
        userId: 'user_elderly_1',
        userName: 'Bpk. Sutrisno',
        caregiverId: 'user_caregiver_1',
        eventType: EmergencyEventType.possibleFall,
        timestamp: now.subtract(const Duration(hours: 3, minutes: 12)),
        latitude: -6.5971,
        longitude: 106.8060,
        locationAvailable: true,
        address: 'Ruang Tamu, Jl. Pajajaran No. 88, Bogor',
        eventStatus: EmergencyEventStatus.handled,
        handledAt: now.subtract(const Duration(hours: 2, minutes: 55)),
        handledNotes: 'Sudah diperiksa oleh Budi Santoso. Kondisi aman hanya terpeleset ringan.',
      ),
      EmergencyEvent(
        eventId: 'EVT-DEMO-002',
        userId: 'user_elderly_1',
        userName: 'Bpk. Sutrisno',
        caregiverId: 'user_caregiver_1',
        eventType: EmergencyEventType.manualSos,
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
        latitude: -6.5944,
        longitude: 106.7992,
        locationAvailable: true,
        address: 'Teras Depan, Jl. Pajajaran No. 88, Bogor',
        eventStatus: EmergencyEventStatus.handled,
        handledAt: now.subtract(const Duration(days: 1, hours: 4, minutes: 40)),
        handledNotes: 'Membutuhkan bantuan mengambilkan obat darah tinggi.',
      ),
      EmergencyEvent(
        eventId: 'EVT-DEMO-003',
        userId: 'user_elderly_1',
        userName: 'Bpk. Sutrisno',
        caregiverId: 'user_caregiver_1',
        eventType: EmergencyEventType.possibleFall,
        timestamp: now.subtract(const Duration(days: 3)),
        latitude: null,
        longitude: null,
        locationAvailable: false,
        address: null,
        eventStatus: EmergencyEventStatus.cancelled,
        handledNotes: 'Dibatalkan oleh Bpk. Sutrisno (HP terjatuh dari meja).',
      ),
    ];
  }

  List<EmergencyEvent> getAllEvents() {
    return List.unmodifiable(_cachedEvents);
  }

  List<EmergencyEvent> getEventsForUser(String userId) {
    return _cachedEvents.where((e) => e.userId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<EmergencyEvent> getEventsForCaregiver(String caregiverId) {
    return _cachedEvents.where((e) => e.caregiverId == caregiverId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<EmergencyEvent> createEmergencyEvent({
    required String userId,
    required String userName,
    required String caregiverId,
    required EmergencyEventType eventType,
    double? latitude,
    double? longitude,
    bool locationAvailable = false,
    String? address,
  }) async {
    final newEvent = EmergencyEvent(
      eventId: 'EVT-${_uuid.v4().substring(0, 8).toUpperCase()}',
      userId: userId,
      userName: userName,
      caregiverId: caregiverId,
      eventType: eventType,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      locationAvailable: locationAvailable,
      address: address,
      eventStatus: EmergencyEventStatus.received,
    );

    _cachedEvents.insert(0, newEvent);
    await _storageService.saveEvents(_cachedEvents);

    _notificationService.pushEmergencyAlert(newEvent);

    return newEvent;
  }

  Future<void> markEventHandled({
    required String eventId,
    required String handledNotes,
  }) async {
    final index = _cachedEvents.indexWhere((e) => e.eventId == eventId);
    if (index != -1) {
      final updated = _cachedEvents[index].copyWith(
        eventStatus: EmergencyEventStatus.handled,
        handledAt: DateTime.now(),
        handledNotes: handledNotes,
      );
      _cachedEvents[index] = updated;
      await _storageService.saveEvents(_cachedEvents);
    }
  }

  Future<void> cancelEvent(String eventId) async {
    final index = _cachedEvents.indexWhere((e) => e.eventId == eventId);
    if (index != -1) {
      final updated = _cachedEvents[index].copyWith(
        eventStatus: EmergencyEventStatus.cancelled,
      );
      _cachedEvents[index] = updated;
      await _storageService.saveEvents(_cachedEvents);
    }
  }
}
