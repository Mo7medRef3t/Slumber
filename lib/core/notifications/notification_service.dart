import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _dailyTimer;

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // 🔥 جدولة تنبيه باستخدام Timer (الحل البسيط والمضمون)
  void scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) {
    // إلغاء أي Timer قديم
    _dailyTimer?.cancel();

    // حساب الفرق بين الوقت الحالي والوقت المطلوب
    final now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // لو الوقت فات النهاردة، خليه بكرة
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    final difference = scheduledDateTime.difference(now);

    debugPrint("🔔 Notification scheduled in: ${difference.inMinutes} minutes");
    debugPrint("🔔 Will fire at: $scheduledDateTime");

    // إنشاء Timer
    _dailyTimer = Timer(difference, () async {
      await _showNotification(id, title, body);

      // إعادة الجدولة لليوم التالي
      scheduleDailyNotification(id: id, title: title, body: body, time: time);
    });
  }

  // عرض التنبيه
  Future<void> _showNotification(int id, String title, String body) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'slumber_reminders',
        'Sleep Reminders',
        channelDescription: 'Reminds you to go to sleep',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(id, title, body, details);
  }

  // إلغاء التنبيه
  Future<void> cancelNotification(int id) async {
    _dailyTimer?.cancel();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // تنبيه فوري للاختبار
  Future<void> showInstantNotification() async {
    await _showNotification(999, 'تست التنبيه 🔔', 'السيستم شغال!');
  }
}
