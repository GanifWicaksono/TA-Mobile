import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum NeumorphicDepth {
  flat,
  subtle,
  raised,
  pressed,
}

class NeumorphicContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final NeumorphicDepth depth;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final ShapeBorder? customShape;

  const NeumorphicContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20.0,
    this.depth = NeumorphicDepth.raised,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderWidth = 0.0,
    this.customShape,
  });

  List<BoxShadow> _getShadows() {
    switch (depth) {
      case NeumorphicDepth.flat:
        return const [];
      case NeumorphicDepth.subtle:
        return AppColors.neumorphicSubtle;
      case NeumorphicDepth.raised:
        return AppColors.neumorphicRaised;
      case NeumorphicDepth.pressed:
        return AppColors.neumorphicPressed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = (borderColor != null && borderWidth > 0)
        ? Border.all(color: borderColor!, width: borderWidth)
        : null;

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: _getShadows(),
        border: border,
      ),
      child: child,
    );
  }
}
