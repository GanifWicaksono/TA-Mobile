import '../../core/models/user_model.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final StorageService _storageService;

  static const UserModel defaultElderly = UserModel(
    id: 'user_elderly_1',
    name: 'Bpk. Sutrisno (72 th)',
    email: 'sutrisno@carelink.id',
    phone: '0812-3456-7890',
    role: UserRole.elderly,
    avatarUrl: null,
    connectedCaregiverId: 'user_caregiver_1',
    connectedCaregiverName: 'Budi Santoso',
    connectedCaregiverPhone: '0813-9876-5432',
    relationship: 'Anak Kandung',
    isMonitoringActive: true,
  );

  static const UserModel defaultCaregiver = UserModel(
    id: 'user_caregiver_1',
    name: 'Budi Santoso',
    email: 'budi.santoso@carelink.id',
    phone: '0813-9876-5432',
    role: UserRole.caregiver,
    avatarUrl: null,
    connectedCaregiverId: null,
    connectedCaregiverName: null,
    connectedCaregiverPhone: null,
    relationship: null,
    isMonitoringActive: false,
  );

  UserModel _currentUser = defaultElderly;

  AuthRepository(this._storageService) {
    final savedRole = _storageService.getUserRole();
    if (savedRole == UserRole.caregiver) {
      _currentUser = defaultCaregiver;
    } else {
      _currentUser = defaultElderly.copyWith(
        isMonitoringActive: _storageService.getMonitoringActive(),
      );
    }
  }

  UserModel get currentUser => _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (role == UserRole.caregiver) {
      _currentUser = defaultCaregiver.copyWith(email: email);
    } else {
      _currentUser = defaultElderly.copyWith(email: email);
    }
    await _storageService.saveUserRole(_currentUser.role);
    return _currentUser;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    String? caregiverName,
    String? caregiverPhone,
    String? relationship,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      connectedCaregiverId: role == UserRole.elderly ? 'user_caregiver_1' : null,
      connectedCaregiverName: caregiverName ?? 'Budi Santoso',
      connectedCaregiverPhone: caregiverPhone ?? '0813-9876-5432',
      relationship: relationship ?? 'Keluarga',
      isMonitoringActive: role == UserRole.elderly,
    );
    await _storageService.saveUserRole(_currentUser.role);
    return _currentUser;
  }

  Future<void> switchRole(UserRole targetRole) async {
    if (targetRole == UserRole.caregiver) {
      _currentUser = defaultCaregiver;
    } else {
      _currentUser = defaultElderly.copyWith(
        isMonitoringActive: _storageService.getMonitoringActive(),
      );
    }
    await _storageService.saveUserRole(targetRole);
  }

  Future<void> updateMonitoring(bool active) async {
    _currentUser = _currentUser.copyWith(isMonitoringActive: active);
    await _storageService.saveMonitoringActive(active);
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _currentUser = defaultElderly;
  }
}
