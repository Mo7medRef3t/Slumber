import 'package:flutter/material.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 845), // الأبعاد اللي اخترتها
      minTextAdapt: true, // يعدل النصوص تلقائيًا حسب كثافة الشاشة
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme, // Default light theme
          darkTheme: AppTheme.darkTheme, // Dark theme
          themeMode: ThemeMode.system, // Follows system theme settings
        );
      },
    );
  }
}
