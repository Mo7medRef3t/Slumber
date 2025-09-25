import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // auto-generated
  );
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
