import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepScoreCircle extends StatelessWidget {
  final int score;
  const SleepScoreCircle({super.key, required this.score});

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.greenAccent;
    if (score >= 75) return Colors.blueAccent;
    if (score >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(score);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // الخلفية الرمادية
            SizedBox(
              height: 180.h,
              width: 180.h,
              child: CircularProgressIndicator(
                value: 1,
                strokeWidth: 15,
                color: Colors.grey.withValues(alpha: 0.1),
                strokeCap: StrokeCap.round,
              ),
            ),
            // مؤشر السكور الفعلي
            SizedBox(
              height: 180.h,
              width: 180.h,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: score / 100),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOutQuart,
                builder: (context, value, _) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 15,
                    color: color,
                    strokeCap: StrokeCap.round,
                  );
                },
              ),
            ),
            // الرقم في النص
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$score",
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  "Sleep Score",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
