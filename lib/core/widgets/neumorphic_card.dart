import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'neumorphic_container.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color? accentBorderColor;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.borderRadius = 22.0,
    this.onTap,
    this.backgroundColor = AppColors.surface,
    this.accentBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final container = NeumorphicContainer(
      margin: margin,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: accentBorderColor,
      borderWidth: accentBorderColor != null ? 1.5 : 0.0,
      depth: NeumorphicDepth.raised,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: container,
      );
    }

    return container;
  }
}
