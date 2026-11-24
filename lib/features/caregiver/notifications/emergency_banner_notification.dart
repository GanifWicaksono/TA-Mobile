import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/emergency_event_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../emergency_detail/emergency_detail_screen.dart';

class EmergencyBannerNotification extends StatelessWidget {
  final EmergencyEvent event;
  final VoidCallback onDismiss;

  const EmergencyBannerNotification({
    super.key,
    required this.event,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.emergencyCoral, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44E97979),
              offset: Offset(0, 6),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'PERINGATAN DARURAT!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.emergencyCoralDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDismiss,
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${event.userName} terdeteksi mengalami kemungkinan jatuh dan membutuhkan perhatian Anda segera.',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Waktu: ${DateFormatter.formatTime(event.timestamp)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onDismiss();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmergencyDetailScreen(event: event),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergencyCoral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'LIHAT DETAIL & LOKASI KEJADIAN',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
