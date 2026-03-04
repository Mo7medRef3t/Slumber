import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> fireNotificationCallback() async {
  final plugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await plugin.initialize(initSettings);

  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool('notifications_enabled') ?? false;

  if (!enabled) return;

  const NotificationDetails details = NotificationDetails(
    android: AndroidNotificationDetails(
      'bedtime_alarm_channel',
      'Bedtime Alarm',
      channelDescription: 'Fires even when app is killed',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    ),
  );

  await plugin.show(
    1,
    'Time to Sleep! 🌙',
    "It's time to wind down and get some rest.",
    details,
  );

  // إعادة الجدولة لبكرة
  final hour = prefs.getInt('reminder_hour');
  final minute = prefs.getInt('reminder_minute');

  if (hour != null && minute != null) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final nextAlarm = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
      hour,
      minute,
    );

    await AndroidAlarmManager.oneShotAt(
      nextAlarm,
      1,
      fireNotificationCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      allowWhileIdle: true,
    );

    debugPrint("🔔 Re-scheduled for tomorrow: $nextAlarm");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await AndroidAlarmManager.initialize();

    debugPrint("✅ NotificationService + AlarmManager initialized");
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    await AndroidAlarmManager.cancel(id);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await AndroidAlarmManager.oneShotAt(
      scheduledDate,
      id,
      fireNotificationCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      allowWhileIdle: true,
    );

    debugPrint("🔔 Alarm scheduled for: $scheduledDate");
    debugPrint(
      "🔔 Minutes remaining: ${scheduledDate.difference(now).inMinutes}",
    );
  }

  Future<void> cancelNotification(int id) async {
    await AndroidAlarmManager.cancel(id);
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint("❌ Alarm $id cancelled");
  }

  Future<void> showInstantNotification() async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'bedtime_alarm_channel',
        'Bedtime Alarm',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      999,
      'Test Notification 🔔',
      'Notifications are working!',
      details,
    );
  }
}
