import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slumber/core/utils/app_colors.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/assets.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _decideNext();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    fadeAnimation = Tween<double>(
      begin: 0.2,
      end: 1,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.dark
            : AppColors.light;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeTransition(
          opacity: fadeAnimation,
          child: Image.asset(
            AssetsData.logo,
            height: 112.h,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          'Slumber',
          textAlign: TextAlign.center,
          style: GoogleFonts.archivo(
            fontSize: 60.sp,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Text(
            'Drift into a night of peaceful, restorative sleep',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, color: colors.secondaryText),
          ),
        ),
      ],
    );
  }

  void _decideNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ✅ User Logged In → Home
        GoRouter.of(context).pushReplacement(AppRouter.kScreens);
      } else {
        // ✅ No User → Onboarding
        GoRouter.of(context).pushReplacement(AppRouter.kOnBordingView);
      }
    });
  }
}
