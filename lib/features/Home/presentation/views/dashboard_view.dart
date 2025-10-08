import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/core/utils/app_router.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _firestoreService = FirestoreService();
  late final FirebaseFirestore _db;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  String _formatTime12(DateTime date) {
    final formatted = DateFormat('hh:mm a').format(date); // e.g. 09:15 PM
    return formatted;
  }

  Future<int> _calculateAverageSleep() async {
    final historySnapshot =
        await _db
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sleepHistory")
            .orderBy("startTime", descending: true)
            .limit(7)
            .get();

    if (historySnapshot.docs.isEmpty) return 0;

    int total = 0;
    for (var doc in historySnapshot.docs) {
      total += doc["duration"] as int;
    }
    return (total / historySnapshot.docs.length).round();
  }

  Future<Map<String, dynamic>?> _getBestSleep() async {
    final snapshot =
        await _db
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sleepHistory")
            .orderBy("duration", descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  Future<List<Map<String, dynamic>>> _getLast7DaysSleep() async {
    final historySnapshot =
        await _db
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sleepHistory")
            .orderBy("startTime", descending: true)
            .limit(7)
            .get();

    final List<Map<String, dynamic>> data = [];
    for (var doc in historySnapshot.docs.reversed) {
      final d = doc.data();
      final start = DateTime.parse(d["startTime"]);
      double hours = (d["duration"] as int) / 60.0;
      data.add({
        "day": DateFormat("E").format(start), // Mon, Tue...
        "hours": hours,
      });
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(title: const Text("Home"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 🕒 Average Sleep Duration
            FutureBuilder<int>(
              future: _calculateAverageSleep(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: 150.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final duration = _formatDuration(snapshot.data!);
                return Card(
                  elevation: 3,
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
                                  colors.primary.withValues(alpha: 0.1),
                                  Colors.white,
                                ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Average Sleep Duration",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          duration,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text("Consistent healthy sleep"),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            // 📈 Sleep Trend Graph
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getLast7DaysSleep(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final data = snapshot.data!;
                final spots =
                    data.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value["hours"] as double,
                      );
                    }).toList();

                return Card(
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
                                      if (index >= data.length)
                                        return const SizedBox();
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
                                  dotData: FlDotData(show: false),
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
            ),

            SizedBox(height: 20.h),

            // 🌟 Best Sleep Day
            FutureBuilder<Map<String, dynamic>?>(
              future: _getBestSleep(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final record = snapshot.data;
                if (record == null) return const SizedBox();

                final duration = _formatDuration(record["duration"]);
                final start = DateTime.parse(record["startTime"]);
                final formattedDate = DateFormat('EEE, MMM d').format(start);
                return Card(
                  color: colors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text("Best Sleep Day"),
                    subtitle: Text("$formattedDate • $duration"),
                    trailing: Text(
                      "🌙 Excellent",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            // 🌙 Last Sleep
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getSleepHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.bedtime_outlined, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "No recent sleep records yet.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final last = snapshot.data!.first;
                final duration = _formatDuration(last["duration"]);
                final start = DateTime.parse(last["startTime"]);
                final end = DateTime.parse(last["endTime"]);
                final timeRange =
                    "${_formatTime12(start)} - ${_formatTime12(end)}";
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bedtime_rounded),
                    title: Text("Last Sleep: $duration"),
                    subtitle: Text(timeRange),
                  ),
                );
              },
            ),

            SizedBox(height: 25.h),

            // 🟣 Start Tracking Button
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.kSleepTrackingView),
              icon: const Icon(Icons.play_circle_outline),
              label: Text(
                "Start Sleep Tracking",
                style: TextStyle(fontSize: 16.sp),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 25.h),

            // 💡 Daily Tip
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.amber),
                title: const Text("Daily Sleep Tip"),
                subtitle: const Text(
                  "Try to avoid caffeine 6 hours before bedtime for better sleep quality.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
