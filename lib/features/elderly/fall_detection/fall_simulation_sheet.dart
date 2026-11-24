import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/services/fall_detection_service.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';

class FallSimulationSheet extends StatelessWidget {
  final FallDetectionService fallService;

  const FallSimulationSheet({
    super.key,
    required this.fallService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.textMuted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Panel Pengujian & Telemetri Sensor',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Fitur ini dirancang untuk mempermudah demonstrasi dan evaluasi algoritma deteksi jatuh tanpa risiko fisik pada perangkat.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          AnimatedBuilder(
            animation: fallService,
            builder: (context, _) {
              return NeumorphicCard(
                borderRadius: 18,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTelemetryRow(
                      'Resultant Akselerasi Saat Ini',
                      '${fallService.currentAcceleration.toStringAsFixed(2)} m/s²',
                    ),
                    const Divider(height: 16),
                    _buildTelemetryRow(
                      'Puncak Benturan Terakhir',
                      '${fallService.peakImpact.toStringAsFixed(2)} m/s²',
                    ),
                    const Divider(height: 16),
                    _buildTelemetryRow(
                      'Kemiringan Perangkat (Tilt)',
                      '${fallService.currentTiltAngle.toStringAsFixed(1)}°',
                    ),
                    const Divider(height: 16),
                    _buildTelemetryRow(
                      'Status Mesin Deteksi',
                      fallService.state.name.toUpperCase(),
                      highlight: true,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          NeumorphicButton(
            onPressed: () {
              Navigator.of(context).pop();
              fallService.simulateFallEvent();
            },
            variant: ButtonVariant.emergency,
            height: 56,
            icon: Icons.play_arrow_rounded,
            child: const Text(
              'PICU SIMULASI JATUH (POSSIBLE_FALL)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          NeumorphicButton(
            onPressed: () => Navigator.of(context).pop(),
            variant: ButtonVariant.neutral,
            height: 52,
            child: const Text('TUTUP PANEL'),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: highlight ? AppColors.primaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
