import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateBox extends StatelessWidget {
  final String message;
  const EmptyStateBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Icon(
              Icons.nightlight_round,
              size: 45.sp,
              color: colors.secondary.withValues(alpha: 0.8),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
