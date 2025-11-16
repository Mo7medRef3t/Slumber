// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class ProfileHeader extends StatelessWidget {
  final SlumberUser user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final extra = theme.extension<ExtraColors>()!;
    final brightness = theme.brightness;
    final textColor =
        brightness == Brightness.dark ? scheme.onSurface : scheme.onBackground;

    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: scheme.primary.withValues(alpha: 0.15),
          child: Icon(Icons.person, size: 60, color: scheme.primary),
        ),
        SizedBox(height: 14.h),
        Text(
          user.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          user.email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: extra.secondaryText,
          ),
        ),
      ],
    );
  }
}
