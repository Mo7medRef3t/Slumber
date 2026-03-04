import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slumber/core/notifications/notification_service.dart';

class GeneralPreferencesCard extends StatefulWidget {
  const GeneralPreferencesCard({super.key});

  @override
  State<GeneralPreferencesCard> createState() => _GeneralPreferencesCardState();
}

class _GeneralPreferencesCardState extends State<GeneralPreferencesCard> {
  bool notificationsEnabled = false;
  TimeOfDay? reminderTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final enabled = prefs.getBool('notifications_enabled') ?? false;
    final savedHour = prefs.getInt('reminder_hour');
    final savedMinute = prefs.getInt('reminder_minute');

    TimeOfDay? savedTime;
    if (savedHour != null && savedMinute != null) {
      savedTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    }

    setState(() {
      notificationsEnabled = enabled;
      reminderTime = savedTime;
    });

    // إعادة جدولة التنبيه لو كان مفعل
    if (enabled && savedTime != null) {
      await NotificationService().scheduleDailyNotification(
        id: 1,
        title: "Time to Sleep! 🌙",
        body: "It's time to wind down and get some rest.",
        time: savedTime,
      );
      debugPrint("🔔 Re-scheduled notification on app start");
    }
  }

  Future<void> _toggleNotifications(bool enable) async {
    final prefs = await SharedPreferences.getInstance();

    if (enable) {
      if (reminderTime == null) {
        final time = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 22, minute: 0),
          helpText: "Select Bedtime Reminder",
        );

        if (time != null) {
          await _saveTimeAndSchedule(time);
        } else {
          return;
        }
      } else {
        await NotificationService().scheduleDailyNotification(
          id: 1,
          title: "Time to Sleep! 🌙",
          body: "It's time to wind down and get some rest.",
          time: reminderTime!,
        );
      }
    } else {
      await NotificationService().cancelNotification(1);
    }

    setState(() => notificationsEnabled = enable);
    await prefs.setBool('notifications_enabled', enable);
  }

  Future<void> _saveTimeAndSchedule(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() => reminderTime = time);

    await prefs.setInt('reminder_hour', time.hour);
    await prefs.setInt('reminder_minute', time.minute);

    await NotificationService().scheduleDailyNotification(
      id: 1,
      title: "Time to Sleep! 🌙",
      body: "It's time to wind down and get some rest.",
      time: time,
    );

    debugPrint("🔔 Saved and scheduled for ${time.hour}:${time.minute}");
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Preferences",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),

            SwitchListTile(
              title: const Text("Bedtime Reminder"),
              subtitle: Text(
                notificationsEnabled && reminderTime != null
                    ? "Reminding daily at ${reminderTime!.format(context)}"
                    : "Receive reminders to sleep on time",
              ),
              activeColor: scheme.primary,
              value: notificationsEnabled,
              onChanged: _toggleNotifications,
            ),

            if (notificationsEnabled)
              TextButton.icon(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        reminderTime ?? const TimeOfDay(hour: 22, minute: 0),
                  );

                  if (time != null) {
                    await _saveTimeAndSchedule(time);
                  }
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text("Change Reminder Time"),
              ),
          ],
        ),
      ),
    );
  }
}
