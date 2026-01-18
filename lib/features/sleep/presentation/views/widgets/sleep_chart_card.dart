import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/sleep/models/sleep_record.dart';

class SleepChartCard extends StatelessWidget {
  final List<SleepRecord> history;
  final int goalHours;

  const SleepChartCard({
    super.key,
    required this.history,
    required this.goalHours,
  });

  @override
  Widget build(BuildContext context) {
    // ناخد آخر 7 أيام ونعكسهم (الأقدم -> الأحدث) عشان الرسم البياني
    final chartData = history.take(7).toList().reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Target vs Reality",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 200.h,
          child: BarChart(
            BarChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              // ضبط المحاور
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                // المحور السفلي (الأيام)
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= chartData.length) {
                        return const SizedBox();
                      }
                      final record = chartData[value.toInt()];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat(
                            'E',
                          ).format(record.startTime), // Sat, Sun, Mon
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // البيانات
              barGroups:
                  chartData.asMap().entries.map((e) {
                    final index = e.key;
                    final record = e.value;
                    final hours = record.durationMinutes / 60.0;
                    final isTargetMet = hours >= goalHours;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: hours,
                          color:
                              isTargetMet
                                  ? Colors.blueAccent
                                  : Colors.grey.withValues(alpha: 0.5),
                          width: 16.w,
                          borderRadius: BorderRadius.circular(4),
                          // الخلفية الرمادية الخفيفة (الحد الأقصى)
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 12, // بنفترض أقصى سكيل 12 ساعة
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
