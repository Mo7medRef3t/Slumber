import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/achievements/data/models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final unlocked = achievement.unlocked;

    return Card(
      elevation: unlocked ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Icon
            CircleAvatar(
              radius: 22,
              backgroundColor: unlocked
                  ? scheme.primary.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.15),
              child: Icon(
                unlocked ? Icons.emoji_events : Icons.lock_outline,
                color: unlocked ? scheme.primary : Colors.grey,
              ),
            ),

            SizedBox(height: 10.h),

            /// Title
            Text(
              achievement.title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15.sp,
              ),
            ),

            SizedBox(height: 4.h),

            /// Description
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              maxLines: 2,
            ),

            const Spacer(),

            /// Progress bar
            LinearProgressIndicator(
              value: achievement.progress,
              minHeight: 5.h,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              color: unlocked ? scheme.primary : Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),

            SizedBox(height: 6.h),

            /// Progress text
            Text(
              unlocked
                  ? "Completed"
                  : "${(achievement.progress * 100).toInt()}% Complete",
              style: TextStyle(
                fontSize: 12.sp,
                color: unlocked ? scheme.primary : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}