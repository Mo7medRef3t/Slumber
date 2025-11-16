import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/features/home/presentation/views/sleep_tracking_view.dart';
import 'package:slumber/features/auth/presentation/views/sign_in_view.dart';
import 'package:slumber/features/auth/presentation/views/sign_up_view.dart';
import 'package:slumber/features/onbording/presentation/views/on_bording_view.dart';
import 'package:slumber/features/profile/presentation/views/edit_profile_view.dart';
import 'package:slumber/features/profile/presentation/views/settings_view.dart';
import 'package:slumber/features/splash/presentation/views/splash_view.dart';
import 'package:slumber/screens.dart';

abstract class AppRouter {
  static const kOnBordingView = '/onBordingView';
  static const kSignUp = '/signup';
  static const kSignIn = '/signin';
  static const kScreens = '/screens';
  static const kSleepTrackingView = "/sleepTracking";
  static const kEditProfileView = "/editProfile";
  static const kSettingsView = "/settings";

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kOnBordingView,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const OnBordingView(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
      ),
      GoRoute(path: kSignUp, builder: (context, state) => const SignUpView()),
      GoRoute(path: kSignIn, builder: (context, state) => const SignInView()),
      GoRoute(path: kScreens, builder: (context, state) => const Screens()),
      GoRoute(
        path: kSleepTrackingView,
        builder: (context, state) => const SleepTrackingView(),
      ),
      GoRoute(
        path:kEditProfileView,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path:kSettingsView,
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
