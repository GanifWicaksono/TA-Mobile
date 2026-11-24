import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/fall_detection_service.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../data/providers/app_state_provider.dart';
import 'dashboard/elderly_dashboard_screen.dart';
import 'activity/elderly_activity_screen.dart';
import 'profile/elderly_profile_screen.dart';
import 'fall_detection/fall_confirmation_dialog.dart';

class ElderlyMainNavigation extends StatefulWidget {
  const ElderlyMainNavigation({super.key});

  @override
  State<ElderlyMainNavigation> createState() => _ElderlyMainNavigationState();
}

class _ElderlyMainNavigationState extends State<ElderlyMainNavigation> {
  int _currentIndex = 0;
  late FallDetectionService _fallDetectionService;
  bool _isDialogShowing = false;

  final List<Widget> _pages = const [
    ElderlyDashboardScreen(),
    ElderlyActivityScreen(),
    ElderlyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fallDetectionService = FallDetectionService();

    final state = Provider.of<AppStateProvider>(context, listen: false);
    if (state.isMonitoringActive) {
      _fallDetectionService.startMonitoring();
    }

    _fallDetectionService.onPossibleFallDetected = _handlePossibleFallDetected;
  }

  void _handlePossibleFallDetected() {
    if (_isDialogShowing || !mounted) return;

    _isDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => FallConfirmationDialog(
        fallDetectionService: _fallDetectionService,
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }

  @override
  void dispose() {
    _fallDetectionService.stopMonitoring();
    _fallDetectionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FallDetectionService>.value(
      value: _fallDetectionService,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            NavItem(
              icon: Icons.home_rounded,
              label: 'Beranda',
            ),
            NavItem(
              icon: Icons.history_rounded,
              label: 'Aktivitas',
            ),
            NavItem(
              icon: Icons.person_rounded,
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
