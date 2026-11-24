import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/emergency_event_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/carelink_app_bar.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/providers/app_state_provider.dart';
import '../emergency_detail/emergency_detail_screen.dart';

class CaregiverHistoryScreen extends StatefulWidget {
  const CaregiverHistoryScreen({super.key});

  @override
  State<CaregiverHistoryScreen> createState() => _CaregiverHistoryScreenState();
}

class _CaregiverHistoryScreenState extends State<CaregiverHistoryScreen> {
  String _selectedFilter = 'SEMUA';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final allEvents = state.caregiverEvents;

    List<EmergencyEvent> filteredEvents = allEvents;
    if (_selectedFilter == 'AKTIF') {
      filteredEvents = allEvents
          .where((e) =>
              e.eventStatus != EmergencyEventStatus.handled &&
              e.eventStatus != EmergencyEventStatus.cancelled)
          .toList();
    } else if (_selectedFilter == 'DITANGANI') {
      filteredEvents = allEvents
          .where((e) => e.eventStatus == EmergencyEventStatus.handled)
          .toList();
    } else if (_selectedFilter == 'DIBATALKAN') {
      filteredEvents = allEvents
          .where((e) => e.eventStatus == EmergencyEventStatus.cancelled)
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Riwayat Kejadian',
        subtitle: 'Log laporan darurat & deteksi sensor',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('SEMUA'),
                  const SizedBox(width: 8),
                  _buildFilterChip('AKTIF'),
                  const SizedBox(width: 8),
                  _buildFilterChip('DITANGANI'),
                  const SizedBox(width: 8),
                  _buildFilterChip('DIBATALKAN'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.neumorphicSubtle,
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in_rounded,
                            size: 34,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Tidak Ada Riwayat',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tidak ada data untuk filter "$_selectedFilter"',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return _buildEventCard(context, event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? const [] : AppColors.neumorphicSubtle,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EmergencyEvent event) {
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
      margin: const EdgeInsets.only(bottom: 14),
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EmergencyDetailScreen(event: event),
          ),
        );
      },
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
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventType.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        event.userName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge(
                label: event.eventStatus.displayName,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            DateFormatter.formatDateTime(event.timestamp),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          if (event.address != null) ...[
            const SizedBox(height: 6),
            Text(
              event.address!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
