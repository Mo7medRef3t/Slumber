import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/sleep/models/sleep_record.dart';

class StatsGrid extends StatelessWidget {
  final List<SleepRecord> history;

  const StatsGrid({super.key, required this.history});

  // 🔥 إصلاح منطق متوسط الوقت
  String _calculateAvgTime(List<SleepRecord> history, bool isBedtime) {
    if (history.isEmpty) return "--:--";

    double totalMinutes = 0;
    int count = 0;

    for (var r in history.take(7)) {
      final dt = isBedtime ? r.startTime : r.endTime;
      int minutes = dt.hour * 60 + dt.minute;

      // التريك: لو بنحسب وقت النوم (Bedtime) والوقت كان الصبح بدري (0 - 5 AM)
      // بنضيف 24 ساعة (1440 دقيقة) عشان نعتبره "امتداد لليلة اللي فاتت"
      if (isBedtime && dt.hour < 12) {
        minutes += 24 * 60;
      }

      totalMinutes += minutes;
      count++;
    }

    if (count == 0) return "--:--";

    int avgTotalMinutes = (totalMinutes / count).round();

    // نرجع نطرح الـ 24 ساعة لو الرقم عدى اليوم
    if (avgTotalMinutes >= 24 * 60) {
      avgTotalMinutes -= 24 * 60;
    }

    final h = avgTotalMinutes ~/ 60;
    final m = avgTotalMinutes % 60;

    // تحويل لنظام 12 ساعة للعرض
    final period = h >= 12 ? "PM" : "AM";
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);

    return "${displayH.toString()}:${m.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _StatBox(
          title: "Avg Bedtime",
          value: _calculateAvgTime(history, true),
          icon: Icons.bedtime,
        ),
        _StatBox(
          title: "Avg Wake-up",
          value: _calculateAvgTime(history, false),
          icon: Icons.wb_sunny,
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(height: 5.h),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          Text(title, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}
