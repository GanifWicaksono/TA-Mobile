import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/custom_bottom_nav.dart';
import '../../data/providers/app_state_provider.dart';
import 'dashboard/caregiver_dashboard_screen.dart';
import 'history/caregiver_history_screen.dart';
import 'profile/caregiver_profile_screen.dart';
import 'notifications/emergency_banner_notification.dart';

class CaregiverMainNavigation extends StatefulWidget {
  const CaregiverMainNavigation({super.key});

  @override
  State<CaregiverMainNavigation> createState() => _CaregiverMainNavigationState();
}

class _CaregiverMainNavigationState extends State<CaregiverMainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    CaregiverDashboardScreen(),
    CaregiverHistoryScreen(),
    CaregiverProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          if (state.activeEmergencyAlert != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EmergencyBannerNotification(
                event: state.activeEmergencyAlert!,
                onDismiss: () => state.dismissEmergencyBanner(),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          NavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
          ),
          NavItem(
            icon: Icons.history_rounded,
            label: 'Riwayat',
          ),
          NavItem(
            icon: Icons.person_rounded,
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
