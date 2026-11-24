class ConnectedElderly {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final String? avatarUrl;
  final bool isMonitoringActive;
  final DateTime lastSeen;
  final int batteryLevel;

  const ConnectedElderly({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.avatarUrl,
    required this.isMonitoringActive,
    required this.lastSeen,
    required this.batteryLevel,
  });

  ConnectedElderly copyWith({
    String? id,
    String? name,
    String? phone,
    String? relationship,
    String? avatarUrl,
    bool? isMonitoringActive,
    DateTime? lastSeen,
    int? batteryLevel,
  }) {
    return ConnectedElderly(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isMonitoringActive: isMonitoringActive ?? this.isMonitoringActive,
      lastSeen: lastSeen ?? this.lastSeen,
      batteryLevel: batteryLevel ?? this.batteryLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'avatarUrl': avatarUrl,
      'isMonitoringActive': isMonitoringActive,
      'lastSeen': lastSeen.toIso8601String(),
      'batteryLevel': batteryLevel,
    };
  }

  factory ConnectedElderly.fromJson(Map<String, dynamic> json) {
    return ConnectedElderly(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      relationship: json['relationship'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isMonitoringActive: json['isMonitoringActive'] as bool? ?? true,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      batteryLevel: json['batteryLevel'] as int? ?? 85,
    );
  }
}
