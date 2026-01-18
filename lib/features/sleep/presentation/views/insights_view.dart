import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import 'package:slumber/features/sleep/data/sleep_score_calculator.dart';
import 'package:slumber/features/sleep/presentation/views/sleep_history_view.dart';
import 'package:slumber/features/sleep/presentation/views/widgets/sleep_chart_card.dart';
import 'package:slumber/features/sleep/presentation/views/widgets/sleep_score_circle.dart';
import 'widgets/sleep_debt_card.dart'; // ✅ Import
import 'widgets/stats_grid.dart'; // ✅ Import

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().user;
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Insights"), centerTitle: true),
      body: BlocBuilder<SleepCubit, SleepState>(
        builder: (context, state) {
          if (state is! SleepLoaded || state.history.isEmpty) {
            return const Center(child: Text("No data. Start tracking sleep!"));
          }

          final avgScore = SleepScoreCalculator.calculateAverageScore(
            state.history,
            user.sleepGoalHours,
          );

          // حساب الـ Debt
          final last7DaysMinutes = state.history
              .take(7)
              .fold(0, (sum, e) => sum + e.durationMinutes);
          final goalMinutes = user.sleepGoalHours * 60 * 7;
          final sleepDebt = (goalMinutes - last7DaysMinutes) / 60;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // 1. Score
                SleepScoreCircle(score: avgScore),
                SizedBox(height: 25.h),

                // 2. Debt Widget (Clean ✨)
                SleepDebtCard(sleepDebt: sleepDebt),
                SizedBox(height: 25.h),

                // 3. Chart
                SleepChartCard(
                  history: state.history,
                  goalHours: user.sleepGoalHours,
                ),
                SizedBox(height: 25.h),

                // 4. Stats Grid (Fixed Logic ✨)
                StatsGrid(history: state.history),

                SizedBox(height: 20.h),

                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SleepHistoryView(),
                        ),
                      ),
                  child: const Text("View All Logs >"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
