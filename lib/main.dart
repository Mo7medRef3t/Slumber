import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/achievements/cubit/achievements_cubit.dart';
import 'package:slumber/features/auth/cubit/auth_cubit.dart';
import 'package:slumber/features/relax/cubit/sound_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/firebase_options.dart';
import 'package:slumber/core/theme/theme_cubit.dart';
import 'package:slumber/core/theme/theme_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slumber/core/notifications/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().init();
  final themeService = ThemeService();
  final themeCubit = ThemeCubit(themeService);
  await themeCubit.loadTheme();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance)),
        BlocProvider(create: (_) => UserCubit(FirestoreService())..loadUser()),
        BlocProvider(
          create: (_) => SleepCubit(FirestoreService())..startListening(),
        ),
        BlocProvider(
          create:
              (context) => AchievementsCubit(
                sleepCubit: context.read<SleepCubit>(),
                userCubit: context.read<UserCubit>(),
              ),
        ),
        BlocProvider(create: (_) => SoundCubit()),
      ],
      child: const SlumberApp(),
    ),
  );
}

class SlumberApp extends StatelessWidget {
  const SlumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 845), // الأبعاد اللي اخترتها
      minTextAdapt: true, // يعدل النصوص تلقائيًا حسب كثافة الشاشة
      splitScreenMode: true,
      builder: (_, __) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: mode,
            );
          },
        );
      },
    );
  }
}
