import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/profile/presentation/views/widgets/general_preferences_card.dart';
import 'package:slumber/features/profile/presentation/views/widgets/theme_mode_card.dart';
import 'package:slumber/features/profile/presentation/views/widgets/delete_account_card.dart';
import 'package:slumber/features/profile/presentation/views/widgets/about_app_card.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _ = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            const GeneralPreferencesCard(),
            SizedBox(height: 20.h),
            const ThemeModeCard(), // 🔄 Theme Switcher
            SizedBox(height: 20.h),
            const DeleteAccountCard(), // ❌ Account actions
            SizedBox(height: 20.h),
            const AboutAppCard(), // ℹ️ Version / info
          ],
        ),
      ),
    );
  }
}
