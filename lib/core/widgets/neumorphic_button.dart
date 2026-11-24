import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/app_colors.dart';
import 'neumorphic_container.dart';

enum ButtonVariant {
  primary,
  secondary,
  emergency,
  safe,
  neutral,
}

class NeumorphicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isFullWidth;
  final IconData? icon;

  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.neutral,
    this.width,
    this.height = 58.0,
    this.borderRadius = 20.0,
    this.padding,
    this.isFullWidth = false,
    this.icon,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  Color _getBackgroundColor() {
    if (widget.onPressed == null) {
      return AppColors.background.withOpacity(0.6);
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.emergency:
        return AppColors.emergencyCoral;
      case ButtonVariant.safe:
        return AppColors.safeMint;
      case ButtonVariant.neutral:
        return AppColors.surface;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) {
      return AppColors.textMuted;
    }
    switch (widget.variant) {
      case ButtonVariant.primary:
      case ButtonVariant.emergency:
      case ButtonVariant.safe:
        return Colors.white;
      case ButtonVariant.secondary:
      case ButtonVariant.neutral:
        return AppColors.textPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final isSpecialColor = widget.variant != ButtonVariant.neutral;

    List<BoxShadow> shadows;
    if (widget.onPressed == null) {
      shadows = const [];
    } else if (_isPressed) {
      shadows = AppColors.neumorphicPressed;
    } else if (isSpecialColor) {
      shadows = [
        BoxShadow(
          color: bgColor.withOpacity(0.4),
          offset: const Offset(0, 6),
          blurRadius: 14,
          spreadRadius: 1,
        ),
        const BoxShadow(
          color: AppColors.shadowLight,
          offset: Offset(-3, -3),
          blurRadius: 6,
        ),
      ];
    } else {
      shadows = AppColors.neumorphicRaised;
    }

    final content = DefaultTextStyle(
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      child: IconTheme(
        data: IconThemeData(color: textColor, size: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon),
              const SizedBox(width: 10),
            ],
            Flexible(child: widget.child),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _isPressed = true);
              HapticFeedback.lightImpact();
            },
      onTapUp: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
            },
      onTapCancel: widget.onPressed == null
          ? null
          : () {
              setState(() => _isPressed = false);
            },
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.isFullWidth ? double.infinity : widget.width,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _isPressed && widget.variant == ButtonVariant.neutral
              ? const Color(0xFFE2EAF2)
              : bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: shadows,
          border: widget.variant == ButtonVariant.neutral
              ? Border.all(color: Colors.white.withOpacity(0.6), width: 1.0)
              : null,
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
