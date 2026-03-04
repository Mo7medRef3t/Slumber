import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepTimerDisplay extends StatelessWidget {
  final Duration elapsed;
  final DateTime? startTime;
  final bool isTracking;

  const SleepTimerDisplay({
    super.key,
    required this.elapsed,
    required this.startTime,
    required this.isTracking,
  });

  String _formatDuration(Duration d) {
    return "${d.inHours.toString().padLeft(2, '0')}:"
        "${(d.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(d.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          isTracking ? Icons.bedtime : Icons.bedtime_outlined,
          size: 80.sp,
          color:
              isTracking
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.3),
        ),

        SizedBox(height: 30.h),
        Text(
          isTracking ? "Tracking your sleep..." : "Ready to sleep?",
          style: TextStyle(
            fontSize: 18.sp,
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ),

        SizedBox(height: 20.h),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _formatDuration(elapsed),
            key: ValueKey(elapsed.inSeconds),
            style: TextStyle(
              fontSize: 55.sp,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        if (isTracking && startTime != null)
          Text(
            "Started at ${startTime!.hour.toString().padLeft(2, '0')}:"
            "${startTime!.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
              fontSize: 14.sp,
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}
