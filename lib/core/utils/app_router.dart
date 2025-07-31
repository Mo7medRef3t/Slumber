import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/features/onbording/presentation/views/on_bording_view.dart';
import 'package:slumber/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kOnBordingView = '/onBordingView';

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
    ],
  );
}
