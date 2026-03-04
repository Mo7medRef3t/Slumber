import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔥 Flag: هل التطبيق اتفتح من الـ Notification؟
// static عشان نقدر نوصلها من أي مكان
class NotificationFlags {
  static bool openedFromSleepNotification = false;
}

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

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      // 🔥 لما اليوزر يدوس على أي Notification
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        if (details.payload == 'sleep_tracking') {
          NotificationFlags.openedFromSleepNotification = true;
        }
      },
    );

    // 🔥 التشييك: هل التطبيق اتفتح من Notification؟ (Cold Start)
    final launchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload == 'sleep_tracking') {
        NotificationFlags.openedFromSleepNotification = true;
        debugPrint("🚀 App launched from sleep tracking notification!");
      }
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await AndroidAlarmManager.initialize();

    debugPrint("✅ NotificationService + AlarmManager initialized");
  }

  // ===== Bedtime Reminder =====
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
  }

  Future<void> cancelNotification(int id) async {
    await AndroidAlarmManager.cancel(id);
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // ===== Ongoing Sleep Notification =====
  Future<void> showOngoingSleepNotification() async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'sleep_tracking_channel',
        'Sleep Tracking',
        channelDescription: 'Shows while sleep tracking is active',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        playSound: false,
        enableVibration: false,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );

    // 🔥 الـ payload = 'sleep_tracking' عشان نعرف إن الدوسة من هنا
    await flutterLocalNotificationsPlugin.show(
      100,
      'Sleep Tracking Active 🌙',
      'Tap to return to Slumber',
      details,
      payload: 'sleep_tracking',
    );
  }

  Future<void> cancelOngoingSleepNotification() async {
    await flutterLocalNotificationsPlugin.cancel(100);
  }

  // ===== Test =====
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
