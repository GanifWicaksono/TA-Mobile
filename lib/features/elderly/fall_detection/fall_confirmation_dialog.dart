import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/constants/app_constants.dart';
import '../../../core/services/fall_detection_service.dart';
import '../../../core/widgets/neumorphic_button.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../data/providers/app_state_provider.dart';

class FallConfirmationDialog extends StatefulWidget {
  final FallDetectionService fallDetectionService;

  const FallConfirmationDialog({
    super.key,
    required this.fallDetectionService,
  });

  @override
  State<FallConfirmationDialog> createState() => _FallConfirmationDialogState();
}

class _FallConfirmationDialogState extends State<FallConfirmationDialog> {
  late int _remainingSeconds;
  Timer? _countdownTimer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = AppConstants.confirmationCountdownSeconds;
    widget.fallDetectionService.enterConfirmation();
    _startTimer();
    HapticFeedback.heavyImpact();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _handleAutoTimeoutEmergency();
      } else {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds <= 5) {
          HapticFeedback.mediumImpact();
        }
      }
    });
  }

  Future<void> _handleAutoTimeoutEmergency() async {
    if (_isProcessing || !mounted) return;
    setState(() => _isProcessing = true);

    final state = Provider.of<AppStateProvider>(context, listen: false);
    widget.fallDetectionService.confirmEmergency();
    await state.reportPossibleFallConfirmed(timedOut: true);

    if (!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Peringatan Darurat Otomatis telah dikirim ke Caregiver!'),
        backgroundColor: AppColors.emergencyCoralDark,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _handleSafe() {
    _countdownTimer?.cancel();
    widget.fallDetectionService.confirmSafe();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alhamdulillah, status Anda aman. Monitoring dilanjutkan.'),
        backgroundColor: AppColors.safeMintDark,
      ),
    );
  }

  Future<void> _handleNeedHelp() async {
    if (_isProcessing || !mounted) return;
    _countdownTimer?.cancel();
    setState(() => _isProcessing = true);

    final state = Provider.of<AppStateProvider>(context, listen: false);
    widget.fallDetectionService.confirmEmergency();
    await state.reportPossibleFallConfirmed(timedOut: false);

    if (!mounted) return;
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Panggilan darurat berhasil dikirim ke keluarga Anda!'),
        backgroundColor: AppColors.emergencyCoralDark,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remainingSeconds / AppConstants.confirmationCountdownSeconds;

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: Colors.transparent,
        child: NeumorphicCard(
          borderRadius: 28,
          accentBorderColor: AppColors.emergencyCoral,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEC),
                  shape: BoxShape.circle,
                  boxShadow: AppColors.emergencyGlow,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.emergencyCoral,
                  size: 46,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Apakah Anda Baik-Baik Saja?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Kami mendeteksi benturan atau kemungkinan Anda terjatuh. Apakah Anda membutuhkan bantuan darurat?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 104,
                    height: 104,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFFE2EAF4),
                      color: progress > 0.3
                          ? AppColors.primary
                          : AppColors.emergencyCoral,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_remainingSeconds',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: progress > 0.3
                              ? AppColors.textPrimary
                              : AppColors.emergencyCoral,
                        ),
                      ),
                      const Text(
                        'detik',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Jika tidak ada respons, CareLink akan otomatis mengirim lokasi dan memanggil keluarga Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 26),

              NeumorphicButton(
                onPressed: _isProcessing ? null : _handleSafe,
                variant: ButtonVariant.safe,
                height: 58,
                isFullWidth: true,
                icon: Icons.check_circle_rounded,
                child: const Text(
                  'SAYA BAIK-BAIK SAJA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              NeumorphicButton(
                onPressed: _isProcessing ? null : _handleNeedHelp,
                variant: ButtonVariant.emergency,
                height: 58,
                isFullWidth: true,
                icon: Icons.emergency_rounded,
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'BUTUH BANTUAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
