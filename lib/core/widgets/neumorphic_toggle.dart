import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';

class NeumorphicToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String activeText;
  final String inactiveText;

  const NeumorphicToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeText = 'AKTIF',
    this.inactiveText = 'NONAKTIF',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 140,
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFE2F5ED) : const Color(0xFFE3EBF4),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFB5C4D5),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    activeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: value ? AppColors.safeMintDark : Colors.transparent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    inactiveText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: !value ? AppColors.textMuted : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? AppColors.safeMint : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  value ? Icons.check_rounded : Icons.power_settings_new_rounded,
                  color: value ? Colors.white : AppColors.textMuted,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
