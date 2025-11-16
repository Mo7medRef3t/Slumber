import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/home/presentation/views/widgets/empty_state_box.dart';

class SleepTrendChart extends StatelessWidget {
  const SleepTrendChart({super.key});

  Future<List<Map<String, dynamic>>> _getLast7DaysSleep() async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sleepHistory")
            .orderBy("startTime", descending: true)
            .limit(7)
            .get();

    final data = <Map<String, dynamic>>[];
    for (var doc in snapshot.docs.reversed) {
      final d = doc.data();
      final start = DateTime.parse(d["startTime"]);
      double hours = (d["duration"] as int) / 60.0;
      data.add({"day": DateFormat("E").format(start), "hours": hours});
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getLast7DaysSleep(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final data = snapshot.data!;
        if (data.isEmpty) {
          return const EmptyStateBox(message: "No sleep data yet.");
        }
        final spots =
            data
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(e.key.toDouble(), e.value["hours"] as double),
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
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final index = value.toInt();
                              if (index >= data.length) return const SizedBox();
                              return Text(
                                data[index]["day"],
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
                            getTitlesWidget:
                                (v, _) => Text(
                                  "${v.toInt()}h",
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: colors.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
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
