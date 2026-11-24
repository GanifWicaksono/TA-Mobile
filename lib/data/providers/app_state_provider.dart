import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/models/emergency_event_model.dart';
import '../../core/models/caregiver_model.dart';
import '../../core/services/location_service.dart';
import '../../core/services/notification_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/emergency_repository.dart';

class AppStateProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final EmergencyRepository _emergencyRepository;
  final NotificationService _notificationService = NotificationService();

  late StreamSubscription<EmergencyEvent> _notificationSubscription;
  EmergencyEvent? _activeEmergencyAlert;
  EmergencyEvent? get activeEmergencyAlert => _activeEmergencyAlert;

  AppStateProvider({
    required AuthRepository authRepository,
    required EmergencyRepository emergencyRepository,
  })  : _authRepository = authRepository,
        _emergencyRepository = emergencyRepository {
    _initAlertSubscription();
  }

  void _initAlertSubscription() {
    _notificationSubscription = _notificationService.onEmergencyReceived.listen((event) {
      if (currentUser.role == UserRole.caregiver) {
        _activeEmergencyAlert = event;
        notifyListeners();
      }
    });
  }

  UserModel get currentUser => _authRepository.currentUser;
  bool get isElderlyMode => currentUser.role == UserRole.elderly;
  bool get isMonitoringActive => currentUser.isMonitoringActive;

  ConnectedElderly get primaryConnectedElderly {
    return ConnectedElderly(
      id: 'user_elderly_1',
      name: 'Bpk. Sutrisno (72 th)',
      phone: '0812-3456-7890',
      relationship: 'Ayah Kandung',
      avatarUrl: null,
      isMonitoringActive: isMonitoringActive,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 2)),
      batteryLevel: 88,
    );
  }

  List<EmergencyEvent> get elderlyEvents =>
      _emergencyRepository.getEventsForUser(currentUser.id);

  List<EmergencyEvent> get caregiverEvents =>
      _emergencyRepository.getEventsForCaregiver('user_caregiver_1');

  EmergencyEvent? get latestEmergencyEvent {
    final events = caregiverEvents;
    if (events.isEmpty) return null;
    return events.first;
  }

  Future<void> toggleMonitoring(bool active) async {
    await _authRepository.updateMonitoring(active);
    notifyListeners();
  }

  Future<void> switchRole(UserRole targetRole) async {
    await _authRepository.switchRole(targetRole);
    notifyListeners();
  }

  Future<EmergencyEvent> triggerManualSos() async {
    final loc = await LocationService.getCurrentLocation();
    final event = await _emergencyRepository.createEmergencyEvent(
      userId: currentUser.id,
      userName: currentUser.name,
      caregiverId: currentUser.connectedCaregiverId ?? 'user_caregiver_1',
      eventType: EmergencyEventType.manualSos,
      latitude: loc.latitude,
      longitude: loc.longitude,
      locationAvailable: loc.isAvailable,
      address: loc.address,
    );
    notifyListeners();
    return event;
  }

  Future<EmergencyEvent> reportPossibleFallConfirmed({required bool timedOut}) async {
    final loc = await LocationService.getCurrentLocation();
    final event = await _emergencyRepository.createEmergencyEvent(
      userId: currentUser.id,
      userName: currentUser.name,
      caregiverId: currentUser.connectedCaregiverId ?? 'user_caregiver_1',
      eventType: EmergencyEventType.possibleFall,
      latitude: loc.latitude,
      longitude: loc.longitude,
      locationAvailable: loc.isAvailable,
      address: loc.address,
    );
    notifyListeners();
    return event;
  }

  Future<void> markEventHandled({
    required String eventId,
    required String handledNotes,
  }) async {
    await _emergencyRepository.markEventHandled(
      eventId: eventId,
      handledNotes: handledNotes,
    );
    if (_activeEmergencyAlert?.eventId == eventId) {
      _activeEmergencyAlert = null;
    }
    notifyListeners();
  }

  void dismissEmergencyBanner() {
    _activeEmergencyAlert = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }
}
