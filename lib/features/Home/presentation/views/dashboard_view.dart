import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/features/home/presentation/views/widgets/avg_sleep_card.dart';
import 'package:slumber/features/home/presentation/views/widgets/best_sleep_card.dart';
import 'package:slumber/features/home/presentation/views/widgets/daily_tip_card.dart';
import 'package:slumber/features/home/presentation/views/widgets/last_sleep_card.dart';
import 'package:slumber/features/home/presentation/views/widgets/sleep_trend_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  "Good evening, ${user?.displayName ?? user?.email?.split('@').first ?? 'Sleeper'} 👋",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const AvgSleepCard(),
            SizedBox(height: 10.h),
            const SleepTrendChart(),
            SizedBox(height: 10.h),
            const BestSleepCard(),
            SizedBox(height: 10.h),
            const LastSleepCard(),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.kSleepTrackingView),
              icon: const Icon(Icons.play_circle_outline),
              label: Text(
                "Start Sleep Tracking",
                style: TextStyle(fontSize: 16.sp),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
              ),
            ),
            SizedBox(height: 20.h),
            const DailyTipCard(),
          ],
        ),
      ),
    );
  }
}
