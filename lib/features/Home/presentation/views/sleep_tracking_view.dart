import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/core/notifications/notification_service.dart';
import 'package:slumber/core/services/sleep_session_service.dart';

class SleepTrackingView extends StatefulWidget {
  const SleepTrackingView({super.key});

  @override
  State<SleepTrackingView> createState() => _SleepTrackingViewState();
}

class _SleepTrackingViewState extends State<SleepTrackingView> {
  final _firestoreService = FirestoreService();
  final _notificationService = NotificationService();

  DateTime? _startTime; // وقت بداية النوم
  Timer? _timer; // عداد التحديث كل ثانية
  Duration _elapsed = Duration.zero; // الوقت اللي فات
  bool _isTracking = false; // هل بنتتبع دلوقتي؟

  @override
  void initState() {
    super.initState();
    _checkActiveSession(); // أول حاجة: نشيك هل فيه جلسة شغالة
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// التشييك على جلسة نوم سابقة
  Future<void> _checkActiveSession() async {
    final savedStart = await SleepSessionService.getActiveSession();

    if (savedStart != null) {
      // 🔥 فيه جلسة شغالة! نكمل العداد من وقت البداية الحقيقي
      setState(() {
        _startTime = savedStart;
        _elapsed = DateTime.now().difference(savedStart);
        _isTracking = true;
      });
      _startTimer();
    }
  }

  /// بدء جلسة نوم جديدة
  Future<void> _startSleep() async {
    final now = DateTime.now();

    // 1. حفظ وقت البداية
    await SleepSessionService.startSession();

    // 2. عرض Notification دايمة
    await _notificationService.showOngoingSleepNotification();

    // 3. تحديث الشاشة
    setState(() {
      _startTime = now;
      _elapsed = Duration.zero;
      _isTracking = true;
    });

    // 4. بدء العداد
    _startTimer();
  }

  /// إيقاف جلسة النوم وحفظ الركورد
  Future<void> _stopSleep() async {
    _timer?.cancel();

    final end = DateTime.now();
    final start = _startTime!;

    // 1. حفظ في Firestore
    await _firestoreService.addSleepRecord(start, end);

    // 2. مسح الجلسة المحفوظة
    await SleepSessionService.endSession();

    // 3. مسح الـ Notification الدايمة
    await _notificationService.cancelOngoingSleepNotification();

    // 4. رسالة نجاح
    if (mounted) {
      final duration = end.difference(start);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Sleep saved! Duration: ${hours}h ${minutes}m"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }

    // 5. Reset
    setState(() {
      _startTime = null;
      _elapsed = Duration.zero;
      _isTracking = false;
    });
  }

  /// تشغيل العداد (يتحدث كل ثانية)
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        setState(() {
          _elapsed = DateTime.now().difference(_startTime!);
        });
      }
    });
  }

  /// تنسيق الوقت (HH:MM:SS)
  String _formatDuration(Duration d) {
    return "${d.inHours.toString().padLeft(2, '0')}:"
        "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Tracking"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة النوم
            Icon(
              _isTracking ? Icons.bedtime : Icons.bedtime_outlined,
              size: 80.sp,
              color:
                  _isTracking
                      ? colors.primary
                      : colors.onSurface.withValues(alpha: 0.3),
            ),

            SizedBox(height: 30.h),

            // حالة التتبع
            Text(
              _isTracking ? "Tracking your sleep..." : "Ready to sleep?",
              style: TextStyle(
                fontSize: 18.sp,
                color: colors.onSurface.withValues(alpha: 0.7),
              ),
            ),

            SizedBox(height: 20.h),

            // العداد
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _formatDuration(_elapsed),
                key: ValueKey(_elapsed.inSeconds),
                style: TextStyle(
                  fontSize: 55.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),

            SizedBox(height: 15.h),

            // وقت البداية
            if (_isTracking && _startTime != null)
              Text(
                "Started at ${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.onSurface.withValues(alpha: 0.5),
                ),
              ),

            SizedBox(height: 50.h),

            // زرار Start / Stop
            ElevatedButton(
              onPressed: _isTracking ? _stopSleep : _startSleep,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isTracking ? Colors.redAccent : colors.primary,
                minimumSize: Size(220.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _isTracking ? "Stop & Save" : "Start Sleep",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
