import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/models/emergency_event_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/carelink_app_bar.dart';
import '../../../core/widgets/neumorphic_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/providers/app_state_provider.dart';

class ElderlyActivityScreen extends StatelessWidget {
  const ElderlyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppStateProvider>(context);
    final events = state.elderlyEvents;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CareLinkAppBar(
        title: 'Riwayat Aktivitas',
        subtitle: 'Catatan kejadian dan status keamanan',
      ),
      body: events.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.neumorphicSubtle,
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      size: 38,
                      color: AppColors.safeMintDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Kejadian Bahaya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Kondisi Anda terpantau aman dan terkendali.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildActivityCard(event);
              },
            ),
    );
  }

  Widget _buildActivityCard(EmergencyEvent event) {
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
      margin: const EdgeInsets.only(bottom: 16),
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
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
                  Text(
                    event.eventType.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.address!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (event.handledNotes != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5EEF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Catatan: ${event.handledNotes!}',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
