import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
  }

  static Future<void> showAchievement(String title) async {
    await _plugin.show(
      0,
      "Achievement Unlocked 🎉",
      title,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'achievements',
          'Achievements',
          importance: Importance.high,
        ),
      ),
    );
  }
}