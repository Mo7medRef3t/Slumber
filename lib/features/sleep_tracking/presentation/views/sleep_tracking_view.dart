import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/core/notifications/notification_service.dart';
import 'package:slumber/core/services/sleep_session_service.dart';
import 'package:slumber/features/relax/cubit/sound_cubit.dart';
import 'widgets/sleep_timer_display.dart';
import 'widgets/sleep_control_button.dart';
import 'widgets/active_sound_indicator.dart';
import 'widgets/sleep_sounds_sheet.dart';

class SleepTrackingView extends StatefulWidget {
  const SleepTrackingView({super.key});

  @override
  State<SleepTrackingView> createState() => _SleepTrackingViewState();
}

class _SleepTrackingViewState extends State<SleepTrackingView> {
  final _firestoreService = FirestoreService();
  final _notificationService = NotificationService();

  DateTime? _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ===== Session Management =====

  Future<void> _checkActiveSession() async {
    final savedStart = await SleepSessionService.getActiveSession();
    if (savedStart != null) {
      setState(() {
        _startTime = savedStart;
        _elapsed = DateTime.now().difference(savedStart);
        _isTracking = true;
      });
      _startTimer();
    }
  }

  Future<void> _startSleep() async {
    final now = DateTime.now();
    await SleepSessionService.startSession();
    await _notificationService.showOngoingSleepNotification();

    setState(() {
      _startTime = now;
      _elapsed = Duration.zero;
      _isTracking = true;
    });

    _startTimer();
  }

  Future<void> _stopSleep() async {
    _timer?.cancel();

    final end = DateTime.now();
    final start = _startTime!;

    // حفظ الركورد
    await _firestoreService.addSleepRecord(start, end);
    await SleepSessionService.endSession();
    await _notificationService.cancelOngoingSleepNotification();

    // إيقاف الصوت
    if (mounted) {
      context.read<SoundCubit>().stopSound();
    }

    if (mounted) {
      final duration = end.difference(start);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Sleep saved! Duration: ${duration.inHours}h ${duration.inMinutes % 60}m",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }

    setState(() {
      _startTime = null;
      _elapsed = Duration.zero;
      _isTracking = false;
    });
  }

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

  // ===== UI =====

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Tracking"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SleepTimerDisplay(
              elapsed: _elapsed,
              startTime: _startTime,
              isTracking: _isTracking,
            ),

            SizedBox(height: 40.h),

            // مؤشر الصوت الشغال
            ActiveSoundIndicator(onTap: () => SleepSoundsSheet.show(context)),

            // زرار Start / Stop
            SleepControlButton(
              isTracking: _isTracking,
              onPressed: _isTracking ? _stopSleep : _startSleep,
            ),

            SizedBox(height: 20.h),

            // زرار فتح الأصوات
            if (_isTracking)
              OutlinedButton.icon(
                onPressed: () => SleepSoundsSheet.show(context),
                icon: Icon(Icons.music_note, color: scheme.primary),
                label: Text(
                  "Sleep Sounds",
                  style: TextStyle(color: scheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: scheme.primary),
                  minimumSize: Size(220.w, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
