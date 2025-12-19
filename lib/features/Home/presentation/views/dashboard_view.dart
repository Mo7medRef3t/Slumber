import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/core/user/cubit/user_state.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'widgets/avg_sleep_card.dart';
import 'widgets/best_sleep_card.dart';
import 'widgets/daily_tip_card.dart';
import 'widgets/last_sleep_card.dart';
import 'widgets/sleep_trend_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is! UserLoaded) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return BlocBuilder<SleepCubit, SleepState>(
            builder: (context, sleepState) {
              if (sleepState is SleepLoading || sleepState is SleepInitial) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (sleepState is SleepLoaded) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Text(
                            "Good evening, ${userState.user.name} 👋",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                        onPressed:
                            () => context.push(AppRouter.kSleepTrackingView),
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
                );
              }

              return const Center(child: Text("Failed to load data"));
            },
          );
        },
      ),
    );
  }
}
