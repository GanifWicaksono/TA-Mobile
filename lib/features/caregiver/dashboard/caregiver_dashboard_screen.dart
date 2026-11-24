import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/emergency_event_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/providers/app_state_provider.dart';
import '../emergency_detail/emergency_detail_screen.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat pagi!';
    if (hour >= 11 && hour < 15) return 'Selamat siang!';
    if (hour >= 15 && hour < 18) return 'Selamat sore!';
    return 'Selamat malam!';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final caregiver = state.currentUser;
    final elderly = state.primaryConnectedElderly;
    final events = state.caregiverEvents;

    final unhandledEvent = events.firstWhere(
      (e) => e.eventStatus != EmergencyEventStatus.handled && e.eventStatus != EmergencyEventStatus.cancelled,
      orElse: () => events.first,
    );
    final hasActiveEmergency = unhandledEvent.eventStatus != EmergencyEventStatus.handled &&
        unhandledEvent.eventStatus != EmergencyEventStatus.cancelled;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        caregiver.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.neumorphicRaised,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (hasActiveEmergency) ...[
                NeumorphicCard(
                  borderRadius: 24,
                  backgroundColor: const Color(0xFFFFF2F2),
                  accentBorderColor: AppColors.emergencyCoral,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.emergencyCoral,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'STATUS DARURAT AKTIF',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.emergencyCoralDark,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          StatusBadge(
                            label: unhandledEvent.eventStatus.displayName,
                            type: BadgeType.emergency,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${unhandledEvent.userName} memerlukan konfirmasi atau bantuan darurat segera.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Waktu kejadian: ${DateFormatter.formatDateTime(unhandledEvent.timestamp)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      NeumorphicButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EmergencyDetailScreen(event: unhandledEvent),
                            ),
                          );
                        },
                        variant: ButtonVariant.emergency,
                        height: 50,
                        isFullWidth: true,
                        child: const Text(
                          'TINDAK LANJUTI SEKARANG',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              NeumorphicCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lansia yang Dipantau',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        StatusBadge(
                          label: elderly.isMonitoringActive ? 'Online & Terjaga' : 'Offline',
                          type: elderly.isMonitoringActive ? BadgeType.safe : BadgeType.neutral,
                          icon: Icons.circle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2EDFC),
                            shape: BoxShape.circle,
                            boxShadow: AppColors.neumorphicSubtle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.elderly_rounded,
                              size: 34,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                elderly.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${elderly.relationship} • ${elderly.phone}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EEF7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.battery_charging_full_rounded,
                                color: AppColors.safeMintDark,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Baterai: ${elderly.batteryLevel}%',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Koneksi: ${DateFormatter.formatRelative(elderly.lastSeen)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Aktivitas & Peringatan Terbaru',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final nav = context.findAncestorStateOfType<_CaregiverMainNavigationState>();
                      nav?.setState(() => nav._currentIndex = 1);
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              ...events.take(3).map((event) => _buildRecentActivityItem(context, event)),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem(BuildContext context, EmergencyEvent event) {
    final isFall = event.eventType == EmergencyEventType.possibleFall;

    BadgeType badgeType;
    switch (event.eventStatus) {
      case EmergencyEventStatus.handled:
        badgeType = BadgeType.safe;
        break;
      case EmergencyEventStatus.received:
      case EmergencyEventStatus.pending:
      case EmergencyEventStatus.sent:
        badgeType = BadgeType.emergency;
        break;
      case EmergencyEventStatus.cancelled:
        badgeType = BadgeType.neutral;
        break;
    }

    return NeumorphicCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EmergencyDetailScreen(event: event),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isFall ? const Color(0xFFFFECEC) : const Color(0xFFEAF2FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFall ? Icons.accessibility_new_rounded : Icons.sos_rounded,
              color: isFall ? AppColors.emergencyCoral : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventType.displayName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.formatRelative(event.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          StatusBadge(
            label: event.eventStatus.displayName,
            type: badgeType,
          ),
        ],
      ),
    );
  }
}
