// core/utils/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color text;
  final Color onSurface;
  final Color secondaryText;
  final Color accent;    // secondary
  final Color onAccent;  // onSecondary
  final Color success;
  final Color error;
  final LinearGradient backgroundGradient;

  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.onSurface,
    required this.secondaryText,
    required this.accent,
    required this.onAccent,
    required this.success,
    required this.error,
    required this.backgroundGradient,
  });

  // 🌙 Dark Theme
  static const AppColors dark = AppColors(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    primary: Color(0xFF4B91E2),
    onPrimary: Colors.white,
    text: Colors.white,
    onSurface: Color(0xFFE0E0E0),
    secondaryText: Color(0xFFB0B0B0),
    accent: Color(0xFF9575CD),
    onAccent: Colors.white,
    success: Color(0xFF4CAF50),
    error: Color(0xFFF44336),
    backgroundGradient: LinearGradient(
      colors: [Color(0xFF0F0F0F), Color(0xFF1E1E1E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // ☀️ Light Theme
  static const AppColors light = AppColors(
    background: Colors.white,
    surface: Color(0xFFF5F5F5),
    primary: Color(0xFF4B91E2),
    onPrimary: Colors.white,
    text: Colors.black,
    onSurface: Color(0xFF202020),
    secondaryText: Color(0xFF666666),
    accent: Color(0xFFD1C4E9),
    onAccent: Colors.black,
    success: Color(0xFF4CAF50),
    error: Color(0xFFD32F2F),
    backgroundGradient: LinearGradient(
      colors: [Colors.white, Color(0xFFF5F5F5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}