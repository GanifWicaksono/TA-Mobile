import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum BadgeType {
  safe,
  warning,
  emergency,
  neutral,
  info,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.neutral,
    this.icon,
  });

  Color _getBadgeColor() {
    switch (type) {
      case BadgeType.safe:
        return const Color(0xFFE2F7EE);
      case BadgeType.warning:
        return const Color(0xFFFFF4E5);
      case BadgeType.emergency:
        return const Color(0xFFFFEBEB);
      case BadgeType.info:
        return const Color(0xFFE6F0FA);
      case BadgeType.neutral:
        return const Color(0xFFE2EAF4);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case BadgeType.safe:
        return AppColors.safeMintDark;
      case BadgeType.warning:
        return const Color(0xFFC77700);
      case BadgeType.emergency:
        return AppColors.emergencyCoralDark;
      case BadgeType.info:
        return AppColors.primaryDark;
      case BadgeType.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBadgeColor();
    final textColor = _getTextColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
