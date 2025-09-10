import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData darkTheme = _buildTheme(AppColors.dark, Brightness.dark);
  static final ThemeData lightTheme = _buildTheme(AppColors.light, Brightness.light);

  static ThemeData _buildTheme(AppColors colors, Brightness brightness) {
    final base = ThemeData(
      brightness: brightness,
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.accent,
        onSecondary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.text,
        error: colors.error,
        onError: colors.onPrimary,
      ),

      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: colors.text,
        displayColor: colors.text,
      ).copyWith(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colors.text,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.text,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: colors.secondaryText,
        ),
      ),

      // 🔝 AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        foregroundColor: colors.text,
        iconTheme: IconThemeData(color: colors.text),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.text,
        ),
      ),

      // 🔘 Buttons (Elevated + Outlined + Text)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          side: BorderSide(color: colors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      // ✏️ TextFields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: colors.secondaryText,fontSize: 14),
        labelStyle: TextStyle(color: colors.secondaryText),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),

      // 📦 Cards
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // 🔽 BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.secondaryText,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),

      // ✅ Chips (Tags, Filters)
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primary.withValues(alpha:0.2),
        labelStyle: TextStyle(color: colors.text),
        secondaryLabelStyle: TextStyle(color: colors.onPrimary),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}