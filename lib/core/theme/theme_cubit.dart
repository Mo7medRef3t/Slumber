import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeService _themeService;
  ThemeCubit(this._themeService) : super(ThemeMode.system);

  // تحميل النسق عند بدء التطبيق
  Future<void> loadTheme() async {
    final mode = await _themeService.getThemeMode();
    emit(mode);
  }

  // تبديل النسق (Light / Dark / System)
  Future<void> setTheme(ThemeMode mode) async {
    await _themeService.saveThemeMode(mode);
    emit(mode);
  }

  // لتحويل النمط الحالي بسرعة
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setTheme(newMode);
  }
}
