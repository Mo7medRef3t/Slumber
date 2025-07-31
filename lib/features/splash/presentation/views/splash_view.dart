import 'package:flutter/material.dart';
import 'package:slumber/core/utils/app_colors.dart';
import 'package:slumber/features/splash/presentation/views/widgets/splash_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors =
        theme.brightness == Brightness.dark ? AppColors.dark : AppColors.light;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.backgroundGradient),
        child: SplashBody(),
      ),
    );
  }
}
