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
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  String elapsedTime = "00:00:00";

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _start() {
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        final d = stopwatch.elapsed;
        elapsedTime =
            "${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
      });
    });
  }

  void _stop() async {
    timer?.cancel();
    stopwatch.stop();

    final end = DateTime.now();
    final start = end.subtract(stopwatch.elapsed);

    await _firestoreService.addSleepRecord(start, end);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Sleep session saved!")));

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });

    setState(() {
      elapsedTime = "00:00:00";
      stopwatch.reset();
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
                elapsedTime,
                key: ValueKey(elapsedTime),
                style: TextStyle(
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: stopwatch.isRunning ? _stop : _start,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    stopwatch.isRunning ? Colors.redAccent : colors.primary,
                minimumSize: Size(220.w, 60.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                stopwatch.isRunning ? "End Sleep" : "Start Sleep",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
