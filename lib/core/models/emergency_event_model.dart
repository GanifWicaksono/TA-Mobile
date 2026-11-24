enum EmergencyEventType {
  possibleFall('POSSIBLE_FALL', 'Kemungkinan Jatuh'),
  manualSos('MANUAL_SOS', 'Bantuan Darurat Manual');

  final String code;
  final String displayName;
  const EmergencyEventType(this.code, this.displayName);

  static EmergencyEventType fromCode(String code) {
    return EmergencyEventType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => EmergencyEventType.possibleFall,
    );
  }
}

enum EmergencyEventStatus {
  pending('PENDING', 'Menunggu'),
  sent('SENT', 'Terkirim'),
  received('RECEIVED', 'Diterima Caregiver'),
  handled('HANDLED', 'Sudah Ditangani'),
  cancelled('CANCELLED', 'Dibatalkan Lansia');

  final String code;
  final String displayName;
  const EmergencyEventStatus(this.code, this.displayName);

  static EmergencyEventStatus fromCode(String code) {
    return EmergencyEventStatus.values.firstWhere(
      (e) => e.code == code,
      orElse: () => EmergencyEventStatus.pending,
    );
  }
}

class EmergencyEvent {
  final String eventId;
  final String userId;
  final String userName;
  final String caregiverId;
  final EmergencyEventType eventType;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final bool locationAvailable;
  final String? address;
  final EmergencyEventStatus eventStatus;
  final DateTime? handledAt;
  final String? handledNotes;

  const EmergencyEvent({
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.caregiverId,
    required this.eventType,
    required this.timestamp,
    this.latitude,
    this.longitude,
    required this.locationAvailable,
    this.address,
    required this.eventStatus,
    this.handledAt,
    this.handledNotes,
  });

  EmergencyEvent copyWith({
    String? eventId,
    String? userId,
    String? userName,
    String? caregiverId,
    EmergencyEventType? eventType,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    bool? locationAvailable,
    String? address,
    EmergencyEventStatus? eventStatus,
    DateTime? handledAt,
    String? handledNotes,
  }) {
    return EmergencyEvent(
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      caregiverId: caregiverId ?? this.caregiverId,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationAvailable: locationAvailable ?? this.locationAvailable,
      address: address ?? this.address,
      eventStatus: eventStatus ?? this.eventStatus,
      handledAt: handledAt ?? this.handledAt,
      handledNotes: handledNotes ?? this.handledNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'caregiverId': caregiverId,
      'eventType': eventType.code,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'locationAvailable': locationAvailable,
      'address': address,
      'eventStatus': eventStatus.code,
      'handledAt': handledAt?.toIso8601String(),
      'handledNotes': handledNotes,
    };
  }

  factory EmergencyEvent.fromJson(Map<String, dynamic> json) {
    return EmergencyEvent(
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? 'Pengguna Lansia',
      caregiverId: json['caregiverId'] as String,
      eventType: EmergencyEventType.fromCode(json['eventType'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      locationAvailable: json['locationAvailable'] as bool? ?? false,
      address: json['address'] as String?,
      eventStatus: EmergencyEventStatus.fromCode(json['eventStatus'] as String),
      handledAt: json['handledAt'] != null
          ? DateTime.parse(json['handledAt'] as String)
          : null,
      handledNotes: json['handledNotes'] as String?,
    );
  }
}
