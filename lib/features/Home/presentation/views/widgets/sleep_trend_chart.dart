import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import 'empty_state_box.dart';

class SleepTrendChart extends StatelessWidget {
  const SleepTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        if (state is! SleepLoaded || state.history.isEmpty) {
          return const EmptyStateBox(message: "No sleep data yet.");
        }

        final data = state.history.take(7).toList().reversed.toList();

        final spots =
            data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(e.key.toDouble(), e.value.durationMinutes / 60),
                )
                .toList();

        return Card(
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sleep Trend (Last 7 Days)",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 180.h,
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) {
                              final i = v.toInt();
                              if (i >= data.length) return const SizedBox();
                              return Text(
                                DateFormat('E').format(data[i].startTime),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colors.secondary,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (v, _) => Text("${v.toInt()}h"),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: colors.primary,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: colors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
