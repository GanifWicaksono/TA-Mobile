import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/emergency_event_model.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveUserRole(UserRole role) async {
    await _prefs.setString(AppConstants.keyUserRole, role.name);
  }

  UserRole? getUserRole() {
    final roleStr = _prefs.getString(AppConstants.keyUserRole);
    if (roleStr == null) return null;
    return roleStr == 'caregiver' ? UserRole.caregiver : UserRole.elderly;
  }

  Future<void> saveMonitoringActive(bool active) async {
    await _prefs.setBool(AppConstants.keyMonitoringActive, active);
  }

  bool getMonitoringActive() {
    return _prefs.getBool(AppConstants.keyMonitoringActive) ?? true;
  }

  Future<void> saveEvents(List<EmergencyEvent> events) async {
    final jsonList = events.map((e) => e.toJson()).toList();
    await _prefs.setString(AppConstants.keyEmergencyEvents, jsonEncode(jsonList));
  }

  List<EmergencyEvent> getEvents() {
    final raw = _prefs.getString(AppConstants.keyEmergencyEvents);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((item) => EmergencyEvent.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
