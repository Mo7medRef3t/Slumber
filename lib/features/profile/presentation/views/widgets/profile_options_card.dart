// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:slumber/features/auth/data/auth_service.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class ProfileOptionsCard extends StatelessWidget {
  final SlumberUser user;
  final VoidCallback? onProfileUpdated;

  const ProfileOptionsCard({
    super.key,
    required this.user,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final extra = Theme.of(context).extension<ExtraColors>()!;
    final authService = AuthService();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: [
            _tile(
              context,
              icon: Icons.edit,
              title: "Edit Profile",
              onTap: () async {
                final updated = await GoRouter.of(
                  context,
                ).push<bool>(AppRouter.kEditProfileView);

                if (updated == true && onProfileUpdated != null) {
                  onProfileUpdated!();
                }
              },
            ),
            _divider(extra),
            _tile(
              context,
              icon: Icons.settings,
              title: "App Settings",
              onTap: () => GoRouter.of(context).push(AppRouter.kSettingsView),
            ),
            _divider(extra),
            _tile(
              context,
              icon: Icons.exit_to_app_rounded,
              title: "Sign Out",
              iconColor: Colors.redAccent,
              titleColor: Colors.redAccent,
              onTap: () async {
                try {
                  await authService.signOut();
                  if (context.mounted) {
                    GoRouter.of(context).go(AppRouter.kSignIn);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign out failed: $e")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final extra = Theme.of(context).extension<ExtraColors>()!;
    return ListTile(
      leading: Icon(icon, color: iconColor ?? scheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? scheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: extra.secondaryText.withValues(alpha: 0.6),
      ),
      onTap: onTap,
    );
  }

  Widget _divider(ExtraColors extra) => Divider(
    thickness: 1,
    height: 0,
    indent: 20,
    endIndent: 20,
    color: extra.secondaryText.withValues(alpha: 0.25),
  );
}
