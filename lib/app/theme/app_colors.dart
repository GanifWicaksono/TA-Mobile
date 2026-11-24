import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C9FE6);
  static const Color primaryDark = Color(0xFF4C82D1);
  static const Color secondary = Color(0xFFB9D8F2);
  static const Color background = Color(0xFFEDF2F8);
  static const Color surface = Color(0xFFEDF2F8);

  static const Color safeMint = Color(0xFF76C9A5);
  static const Color safeMintDark = Color(0xFF4FA880);

  static const Color emergencyCoral = Color(0xFFE97979);
  static const Color emergencyCoralDark = Color(0xFFD65858);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF78889B);
  static const Color textOnPrimary = Colors.white;

  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFB6C4D6);
  static const Color shadowSubtle = Color(0x33A6B4C6);

  static const Color divider = Color(0xFFD5DFEC);
  static const Color inputBorder = Color(0xFFCBD8E6);

  static const List<BoxShadow> neumorphicRaised = [
    BoxShadow(
      color: shadowLight,
      offset: Offset(-5, -5),
      blurRadius: 10,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowDark,
      offset: Offset(5, 5),
      blurRadius: 10,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> neumorphicSubtle = [
    BoxShadow(
      color: shadowLight,
      offset: Offset(-3, -3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowDark,
      offset: Offset(3, 3),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> neumorphicPressed = [
    BoxShadow(
      color: shadowDark,
      offset: Offset(-3, -3),
      blurRadius: 5,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowLight,
      offset: Offset(3, 3),
      blurRadius: 5,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> emergencyGlow = [
    BoxShadow(
      color: Color(0x55E97979),
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}
