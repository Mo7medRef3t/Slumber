import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/core/user/cubit/user_state.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';

class AvgSleepCard extends StatelessWidget {
  const AvgSleepCard({super.key});

  String _format(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return "${h}h ${m.toString().padLeft(2, '0')}m";
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is! UserLoaded) return const SizedBox();

        return BlocBuilder<SleepCubit, SleepState>(
          builder: (context, sleepState) {
            if (sleepState is! SleepLoaded) return const SizedBox();

            final avg = sleepState.avgHours;
            final goal = userState.user.sleepGoalHours.toDouble();

            return Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        brightness == Brightness.dark
                            ? [Colors.black, Colors.black12]
                            : [
                              colors.primary.withValues(alpha: 0.15),
                              Colors.white,
                            ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Average Sleep Duration",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _format(avg),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text("Consistent healthy sleep"),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: (avg / goal).clamp(0, 1),
                      color: colors.primary,
                      backgroundColor: colors.primary.withValues(alpha: 0.15),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${((avg / goal) * 100).toStringAsFixed(0)}% of goal reached",
                      style: TextStyle(color: colors.primary, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
