import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = _buildTheme(AppColors.dark, Brightness.dark);
  static final ThemeData lightTheme = _buildTheme(AppColors.light, Brightness.light);

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.accent,
        onSecondary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.text,
        background: colors.background,
        onBackground: colors.text,
        error: colors.error,
        onError: colors.onPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: colors.text,
        displayColor: colors.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        foregroundColor: colors.text,
      ),
    );
  }
}
