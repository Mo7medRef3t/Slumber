import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/firebase_options.dart';
import 'package:slumber/core/theme/theme_cubit.dart';
import 'package:slumber/core/theme/theme_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main()   async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // auto-generated
  );
  final themeService = ThemeService();
  final themeCubit = ThemeCubit(themeService);
  await themeCubit.loadTheme();

  runApp(SlumberApp(themeCubit: themeCubit));
}

class SlumberApp extends StatelessWidget {
  final ThemeCubit themeCubit;
  const SlumberApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 845), // الأبعاد اللي اخترتها
      minTextAdapt: true, // يعدل النصوص تلقائيًا حسب كثافة الشاشة
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider.value(
          value: themeCubit,
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode, // ← ديناميكي حسب Cubit
              );
            },
          ),
        );
      },
    );
  }
}
