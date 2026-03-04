import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/services/sleep_session_service.dart';
import 'package:slumber/core/utils/app_router.dart';

class ActiveSessionBanner extends StatefulWidget {
  const ActiveSessionBanner({super.key});

  @override
  State<ActiveSessionBanner> createState() => _ActiveSessionBannerState();
}

class _ActiveSessionBannerState extends State<ActiveSessionBanner>
    with SingleTickerProviderStateMixin {
  bool _hasActiveSession = false;
  String _elapsedText = "";
  Timer? _checkTimer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _checkTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkSession();
    });

    _checkSession();
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final startTime = await SleepSessionService.getActiveSession();

    if (!mounted) return;

    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime);
      final hours = elapsed.inHours;
      final minutes = elapsed.inMinutes % 60;
      final seconds = elapsed.inSeconds % 60;

      setState(() {
        _hasActiveSession = true;
        _elapsedText =
            "${hours.toString().padLeft(2, '0')}:"
            "${minutes.toString().padLeft(2, '0')}:"
            "${seconds.toString().padLeft(2, '0')}";
      });
    } else {
      if (_hasActiveSession) {
        setState(() {
          _hasActiveSession = false;
          _elapsedText = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasActiveSession) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: _pulseAnimation,
      child: GestureDetector(
        onTap: () => context.push(AppRouter.kSleepTrackingView),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.primary,
                colors.primary.withValues(alpha:0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha:0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bedtime,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sleep Tracking Active",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "$_elapsedText • Tap to continue",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha:0.8),
                        fontSize: 13.sp,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha:0.8),
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}