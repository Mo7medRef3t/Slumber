import 'package:slumber/features/sleep/models/sleep_record.dart';

class SleepScoreCalculator {
  /// حساب سكور اليوم الواحد (0 - 100)
  static int calculateDailyScore(SleepRecord record, int goalHours) {
    // 1. Duration Score (70% من النتيجة)
    // لو نمت الهدف كله تاخد 70 نقطة كاملة
    double durationInHours = record.durationMinutes / 60.0;
    double durationScore = (durationInHours / goalHours).clamp(0.0, 1.0) * 70;

    // 2. Consistency Score (30% من النتيجة)
    // لو نمت في وقت منطقي (بين 9 مساءً و 2 صباحًا) تاخد بونص
    double consistencyScore = 0;
    int hour = record.startTime.hour;

    // وقت مثالي: 9 PM (21) إلى 12 AM (0)
    if (hour >= 21 || hour == 0) {
      consistencyScore = 30;
    }
    // وقت متأخر شوية: 1 AM إلى 3 AM
    else if (hour >= 1 && hour <= 3) {
      consistencyScore = 15;
    }
    // وقت سيء: أي وقت تاني
    else {
      consistencyScore = 5;
    }

    return (durationScore + consistencyScore).round();
  }

  /// حساب متوسط السكور للأسبوع كله
  static int calculateAverageScore(List<SleepRecord> history, int goalHours) {
    if (history.isEmpty) return 0;

    // ناخد آخر 7 أيام بس
    final last7Days = history.take(7).toList();

    int totalScore = 0;
    for (var record in last7Days) {
      totalScore += calculateDailyScore(record, goalHours);
    }

    return (totalScore / last7Days.length).round();
  }

  /// تقييم نصي للسكور
  static String getSleepQuality(int score) {
    if (score >= 90) return "Excellent 🏆";
    if (score >= 75) return "Good 🌿";
    if (score >= 50) return "Fair 😐";
    return "Needs Care ⚠️";
  }
}
