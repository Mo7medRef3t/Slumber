import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvgSleepCard extends StatefulWidget {
  const AvgSleepCard({super.key});

  @override
  State<AvgSleepCard> createState() => _AvgSleepCardState();
}

class _AvgSleepCardState extends State<AvgSleepCard> {
  final _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getUserAndAverage() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 🧮 حساب المتوسط
    final historySnapshot =
        await _db
            .collection("users")
            .doc(uid)
            .collection("sleepHistory")
            .orderBy("startTime", descending: true)
            .limit(7)
            .get();

    int avgMinutes = 0;
    if (historySnapshot.docs.isNotEmpty) {
      int total = 0;
      for (var doc in historySnapshot.docs) {
        total += doc["duration"] as int;
      }
      avgMinutes = (total / historySnapshot.docs.length).round();
    }

    // 📥 جلب بيانات المستخدم (عشان goal)
    final userDoc = await _db.collection("users").doc(uid).get();
    final goal = (userDoc.data()?["sleepGoalHours"] ?? 8).toDouble();

    return {"avgMinutes": avgMinutes, "goalHours": goal};
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserAndAverage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 150.h,
            child: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        final data = snapshot.data!;
        final duration = _formatDuration(data["avgMinutes"]);
        final avgHours = data["avgMinutes"] / 60.0;
        final goal = data["goalHours"];

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
                        : [colors.primary.withValues(alpha: 0.15), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                  duration,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text("Consistent healthy sleep"),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: (avgHours / goal).clamp(0, 1),
                  color: colors.primary,
                  backgroundColor: colors.primary.withValues(alpha: 0.15),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(6),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${((avgHours / goal) * 100).toStringAsFixed(0)}% of goal reached",
                  style: TextStyle(color: colors.primary, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
