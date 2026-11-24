import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../data/providers/app_state_provider.dart';

class SosConfirmationDialog extends StatefulWidget {
  const SosConfirmationDialog({super.key});

  @override
  State<SosConfirmationDialog> createState() => _SosConfirmationDialogState();
}

class _SosConfirmationDialogState extends State<SosConfirmationDialog> {
  bool _isSending = false;

  Future<void> _handleConfirmSos() async {
    setState(() => _isSending = true);
    final state = Provider.of<AppStateProvider>(context, listen: false);

    await state.triggerManualSos();

    if (!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panggilan Bantuan Darurat berhasil dikirim ke Caregiver!'),
        backgroundColor: AppColors.emergencyCoralDark,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final caregiverName = state.currentUser.connectedCaregiverName ?? 'Keluarga';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: NeumorphicCard(
        borderRadius: 26,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEC),
                shape: BoxShape.circle,
                boxShadow: AppColors.emergencyGlow,
              ),
              child: const Icon(
                Icons.sos_rounded,
                color: AppColors.emergencyCoral,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Konfirmasi Panggilan Darurat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'CareLink akan mengirimkan koordinat lokasi Anda saat ini dan notifikasi darurat prioritas tinggi kepada $caregiverName.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 26),
            NeumorphicButton(
              onPressed: _isSending ? null : _handleConfirmSos,
              variant: ButtonVariant.emergency,
              height: 58,
              isFullWidth: true,
              icon: Icons.send_rounded,
              child: _isSending
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'YA, KIRIM BANTUAN SEKARANG',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            NeumorphicButton(
              onPressed: _isSending ? null : () => Navigator.of(context).pop(),
              variant: ButtonVariant.neutral,
              height: 54,
              isFullWidth: true,
              child: const Text('BATALKAN'),
            ),
          ],
        ),
      ),
    );
  }
}
