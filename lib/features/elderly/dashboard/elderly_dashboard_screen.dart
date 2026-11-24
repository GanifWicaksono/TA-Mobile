import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/fall_detection_service.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/neumorphic_container.dart';
import '../../../core/widgets/neumorphic_toggle.dart';
import '../../../core/widgets/pulse_sos_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/providers/app_state_provider.dart';
import '../emergency/sos_confirmation_dialog.dart';
import '../fall_detection/fall_simulation_sheet.dart';

class ElderlyDashboardScreen extends StatelessWidget {
  const ElderlyDashboardScreen({super.key});

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
    final user = state.currentUser;
    final fallService = Provider.of<FallDetectionService>(context);

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
                        user.name,
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
                        Icons.person_rounded,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              NeumorphicCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                accentBorderColor: state.isMonitoringActive
                    ? AppColors.safeMint.withOpacity(0.5)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: state.isMonitoringActive
                                    ? const Color(0xFFE2F7EE)
                                    : const Color(0xFFE2EAF4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                state.isMonitoringActive
                                    ? Icons.sensors_rounded
                                    : Icons.sensors_off_rounded,
                                color: state.isMonitoringActive
                                    ? AppColors.safeMintDark
                                    : AppColors.textMuted,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Deteksi Jatuh',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  state.isMonitoringActive
                                      ? 'Monitoring Aktif'
                                      : 'Monitoring Dijeda',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: state.isMonitoringActive
                                        ? AppColors.safeMintDark
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        NeumorphicToggle(
                          value: state.isMonitoringActive,
                          onChanged: (val) {
                            state.toggleMonitoring(val);
                            if (val) {
                              fallService.startMonitoring();
                            } else {
                              fallService.stopMonitoring();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6EEF7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            state.isMonitoringActive
                                ? Icons.shield_rounded
                                : Icons.info_outline_rounded,
                            color: state.isMonitoringActive
                                ? AppColors.safeMintDark
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.isMonitoringActive
                                  ? 'CareLink sedang menjaga keamanan Anda secara otomatis.'
                                  : 'Aktifkan sakelar di atas agar sensor dapat mendeteksi bahaya.',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Center(
                child: Column(
                  children: [
                    PulseSosButton(
                      size: 150,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const SosConfirmationDialog(),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tekan tombol merah di atas jika Anda butuh pertolongan cepat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              NeumorphicCard(
                borderRadius: 22,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2EDFC),
                        shape: BoxShape.circle,
                        boxShadow: AppColors.neumorphicSubtle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.family_restroom_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Keluarga Terhubung',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.connectedCaregiverName ?? 'Budi Santoso',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            user.relationship ?? 'Anak Kandung',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const StatusBadge(
                      label: 'Siaga',
                      type: BadgeType.safe,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              NeumorphicCard(
                borderRadius: 22,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Perangkat & Izin',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickStatusItem(
                          icon: Icons.wifi_rounded,
                          label: 'Internet',
                          status: 'Terhubung',
                          color: AppColors.safeMintDark,
                        ),
                        _buildQuickStatusItem(
                          icon: Icons.vibration_rounded,
                          label: 'Sensor Gerak',
                          status: 'Normal',
                          color: AppColors.safeMintDark,
                        ),
                        _buildQuickStatusItem(
                          icon: Icons.location_on_rounded,
                          label: 'GPS Lokasi',
                          status: 'Aktif',
                          color: AppColors.safeMintDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => FallSimulationSheet(
                      fallService: fallService,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2EAF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.science_outlined, color: AppColors.primaryDark, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Panel Uji Coba & Simulasi Sensor Jatuh',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatusItem({
    required IconData icon,
    required String label,
    required String status,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
