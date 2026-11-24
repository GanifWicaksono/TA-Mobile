import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/carelink_app_bar.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../authentication/login_screen.dart';
import '../../elderly/elderly_main_navigation.dart';

class CaregiverProfileScreen extends StatefulWidget {
  const CaregiverProfileScreen({super.key});

  @override
  State<CaregiverProfileScreen> createState() => _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  bool _pushNotificationEnabled = true;
  bool _criticalAlertsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final caregiver = state.currentUser;
    final elderly = state.primaryConnectedElderly;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Profil Caregiver',
        subtitle: 'Pengaturan pendampingan & akun keluarga',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.neumorphicRaised,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shield_rounded,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caregiver.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          caregiver.phone,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          caregiver.email,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            NeumorphicCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lansia Terhubung',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2EDFC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.elderly_rounded,
                          color: AppColors.primary,
                          size: 26,
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
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${elderly.relationship} • ${elderly.phone}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            NeumorphicCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pengaturan Notifikasi Darurat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Push Notification Real-time',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Menerima notifikasi langsung saat terdeteksi jatuh',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _pushNotificationEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _pushNotificationEnabled = val),
                  ),
                  const Divider(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Critical Alert Prioritas Tinggi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Tetap berbunyi meskipun ponsel dalam mode hening (DND)',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _criticalAlertsEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _criticalAlertsEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            NeumorphicButton(
              onPressed: () async {
                await state.switchRole(UserRole.elderly);
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ElderlyMainNavigation()),
                );
              },
              variant: ButtonVariant.secondary,
              height: 56,
              icon: Icons.swap_horiz_rounded,
              child: const Text(
                'BERALIH KE MODE LANSIA',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),

            NeumorphicButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              variant: ButtonVariant.neutral,
              height: 54,
              icon: Icons.logout_rounded,
              child: const Text(
                'KELUAR DARI AKUN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.emergencyCoralDark,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
