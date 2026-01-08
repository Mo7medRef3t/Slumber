// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/firestore_service.dart';

class SleepTrackingView extends StatefulWidget {
  const SleepTrackingView({super.key});

  @override
  State<SleepTrackingView> createState() => _SleepTrackingViewState();
}

class _SleepTrackingViewState extends State<SleepTrackingView> {
  final _firestoreService = FirestoreService();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = "00:00:00";

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final d = _stopwatch.elapsed;
      setState(() {
        _elapsedTime =
            "${d.inHours.toString().padLeft(2, '0')}:"
            "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
            "${(d.inSeconds % 60).toString().padLeft(2, '0')}";
      });
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _stopwatch.stop();

    final end = DateTime.now();
    final start = end.subtract(_stopwatch.elapsed);

    // ✅ Save to Firestore
    await _firestoreService.addSleepRecord(start, end);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Sleep session saved!")));

    if (mounted) {
      Navigator.pop(context);
    }

    setState(() {
      _elapsedTime = "00:00:00";
      _stopwatch.reset();
    });
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _elapsedTime,
                key: ValueKey(_elapsedTime),
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: _stopwatch.isRunning ? _stop : _start,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _stopwatch.isRunning ? Colors.redAccent : colors.primary,
                minimumSize: Size(220.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _stopwatch.isRunning ? "End Sleep" : "Start Sleep",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
