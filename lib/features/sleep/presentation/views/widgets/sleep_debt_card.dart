import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SleepDebtCard extends StatelessWidget {
  final double sleepDebt;

  const SleepDebtCard({super.key, required this.sleepDebt});

  @override
  Widget build(BuildContext context) {
    final bool hasDebt = sleepDebt > 0;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:
            hasDebt
                ? Colors.redAccent.withValues(alpha: 0.1)
                : Colors.greenAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasDebt ? Colors.redAccent : Colors.greenAccent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasDebt ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: hasDebt ? Colors.redAccent : Colors.green,
            size: 30,
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasDebt ? "Sleep Debt Detected" : "Well Rested",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Text(
                hasDebt
                    ? "You owe your body ${sleepDebt.toStringAsFixed(1)}h"
                    : "You are on track this week!",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
