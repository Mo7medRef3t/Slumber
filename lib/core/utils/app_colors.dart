import 'package:flutter/material.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color text;
  final Color secondaryText;
  final Color accent;
  final Color success;
  final Color error;
  final LinearGradient backgroundGradient;

  const AppColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.secondaryText,
    required this.accent,
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
    secondaryText: Color(0xFFB0B0B0),
    accent: Color(0xFF9575CD),
    success: Color(0xFF4CAF50),
    error: Color(0xFFF44336),
    backgroundGradient: LinearGradient(
      colors: [Colors.black, Color(0xFF1E1E1E)],
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
    secondaryText: Color(0xFF666666),
    accent: Color(0xFFD1C4E9),
    success: Color(0xFF4CAF50),
    error: Color(0xFFF44336),
    backgroundGradient: LinearGradient(
      colors: [Colors.white, Color(0xFFF5F5F5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
