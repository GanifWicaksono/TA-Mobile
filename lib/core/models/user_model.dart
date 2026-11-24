enum UserRole {
  elderly,
  caregiver,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String? connectedCaregiverId;
  final String? connectedCaregiverName;
  final String? connectedCaregiverPhone;
  final String? relationship;
  final bool isMonitoringActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.connectedCaregiverId,
    this.connectedCaregiverName,
    this.connectedCaregiverPhone,
    this.relationship,
    this.isMonitoringActive = true,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? avatarUrl,
    String? connectedCaregiverId,
    String? connectedCaregiverName,
    String? connectedCaregiverPhone,
    String? relationship,
    bool? isMonitoringActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      connectedCaregiverId: connectedCaregiverId ?? this.connectedCaregiverId,
      connectedCaregiverName: connectedCaregiverName ?? this.connectedCaregiverName,
      connectedCaregiverPhone: connectedCaregiverPhone ?? this.connectedCaregiverPhone,
      relationship: relationship ?? this.relationship,
      isMonitoringActive: isMonitoringActive ?? this.isMonitoringActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'connectedCaregiverId': connectedCaregiverId,
      'connectedCaregiverName': connectedCaregiverName,
      'connectedCaregiverPhone': connectedCaregiverPhone,
      'relationship': relationship,
      'isMonitoringActive': isMonitoringActive,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] == 'caregiver' ? UserRole.caregiver : UserRole.elderly,
      avatarUrl: json['avatarUrl'] as String?,
      connectedCaregiverId: json['connectedCaregiverId'] as String?,
      connectedCaregiverName: json['connectedCaregiverName'] as String?,
      connectedCaregiverPhone: json['connectedCaregiverPhone'] as String?,
      relationship: json['relationship'] as String?,
      isMonitoringActive: json['isMonitoringActive'] as bool? ?? true,
    );
  }
}
