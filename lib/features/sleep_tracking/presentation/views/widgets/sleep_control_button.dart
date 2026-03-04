import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepControlButton extends StatelessWidget {
  final bool isTracking;
  final VoidCallback onPressed;

  const SleepControlButton({
    super.key,
    required this.isTracking,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isTracking ? Colors.redAccent : scheme.primary,
        minimumSize: Size(220.w, 60.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        isTracking ? "Stop & Save" : "Start Sleep",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
