import 'dart:async';
import '../models/emergency_event_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _emergencyController = StreamController<EmergencyEvent>.broadcast();
  Stream<EmergencyEvent> get onEmergencyReceived => _emergencyController.stream;

  EmergencyEvent? _lastPushedEvent;
  EmergencyEvent? get lastPushedEvent => _lastPushedEvent;

  void pushEmergencyAlert(EmergencyEvent event) {
    _lastPushedEvent = event;
    _emergencyController.add(event);
  }

  void clearPushedAlert() {
    _lastPushedEvent = null;
  }

  void dispose() {
    _emergencyController.close();
  }
}
