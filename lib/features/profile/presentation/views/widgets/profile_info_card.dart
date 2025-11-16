import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class ProfileInfoCard extends StatelessWidget {
  final SlumberUser user;
  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final extra = Theme.of(context).extension<ExtraColors>()!;
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Full Name", user.name, scheme, extra),
            Divider(
              color: extra.secondaryText.withValues(alpha: 0.15),
              height: 24,
            ),
            _infoRow("Age", "${user.age} years", scheme, extra),
            Divider(
              color: extra.secondaryText.withValues(alpha: 0.15),
              height: 24,
            ),
            _infoRow(
              "Sleep Goal",
              "${user.sleepGoalHours} h/night",
              scheme,
              extra,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
    ColorScheme scheme,
    ExtraColors extra,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15.sp, color: extra.secondaryText),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            color: scheme.primary,
          ),
        ),
      ],
    );
  }
}
