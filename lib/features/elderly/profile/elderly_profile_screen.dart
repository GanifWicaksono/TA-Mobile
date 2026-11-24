import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/carelink_app_bar.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../data/providers/app_state_provider.dart';
import '../../authentication/login_screen.dart';
import '../../caregiver/caregiver_main_navigation.dart';

class ElderlyProfileScreen extends StatefulWidget {
  const ElderlyProfileScreen({super.key});

  @override
  State<ElderlyProfileScreen> createState() => _ElderlyProfileScreenState();
}

class _ElderlyProfileScreenState extends State<ElderlyProfileScreen> {
  bool _soundAlertEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Profil & Pengaturan',
        subtitle: 'Pengaturan akun dan sistem pendamping',
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
                        Icons.elderly_rounded,
                        size: 36,
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
                          user.name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
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
                    'Keluarga Pendamping Utama',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildInfoRow(
                    Icons.person_outline_rounded,
                    'Nama Caregiver',
                    user.connectedCaregiverName ?? 'Budi Santoso',
                  ),
                  const Divider(height: 18),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'Nomor Panggilan Darurat',
                    user.connectedCaregiverPhone ?? '0813-9876-5432',
                  ),
                  const Divider(height: 18),
                  _buildInfoRow(
                    Icons.favorite_outline_rounded,
                    'Hubungan',
                    user.relationship ?? 'Anak Kandung',
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
                    'Preferensi Respon & Peringatan',
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
                      'Bunyi Sirine Alarm Saat Jatuh',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Mengeluarkan bunyi nyaring saat deteksi konfirmasi',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _soundAlertEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _soundAlertEnabled = val),
                  ),
                  const Divider(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Getaran Kuat (Haptic)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: const Text(
                      'Bergetar terus menerus selama masa konfirmasi 30 detik',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    value: _vibrationEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _vibrationEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            NeumorphicButton(
              onPressed: () async {
                await state.switchRole(UserRole.caregiver);
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CaregiverMainNavigation()),
                );
              },
              variant: ButtonVariant.secondary,
              height: 56,
              icon: Icons.swap_horiz_rounded,
              child: const Text(
                'BERALIH KE MODE CAREGIVER',
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
