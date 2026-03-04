import 'package:shared_preferences/shared_preferences.dart';

class SleepSessionService {
  static const String _key = 'sleep_start_time';

  /// حفظ وقت بداية النوم
  static Future<void> startSession() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    await prefs.setString(_key, now);
  }

  /// قراءة وقت البداية (لو موجود)
  static Future<DateTime?> getActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved == null) return null;
    return DateTime.parse(saved);
  }

  /// هل فيه جلسة نوم شغالة؟
  static Future<bool> hasActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key);
  }

  /// إنهاء الجلسة (مسح البيانات)
  static Future<void> endSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
