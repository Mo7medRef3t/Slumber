import 'package:slumber/features/sleep/models/sleep_record.dart';
import 'models/achievement.dart';

class AchievementsRules {
  static List<Achievement> evaluate(
    List<SleepRecord> history,
    int sleepGoalHours,
  ) {
    return [
      _firstSleep(history),
      _sevenDayStreak(history),
      _perfectSleeper(history, sleepGoalHours),
      _earlyRiser(history),
      _nightOwl(history),
      _consistentSleeper(history),
    ];
  }

  static Achievement _firstSleep(List<SleepRecord> history) {
    final unlocked = history.isNotEmpty;
    return Achievement(
      type: AchievementType.firstSleep,
      title: "First Sleep Logged",
      description: "Track your first sleep session",
      unlocked: unlocked,
      progress: unlocked ? 1 : 0,
    );
  }

  static Achievement _sevenDayStreak(List<SleepRecord> history) {
    final days =
        history
            .map(
              (e) => DateTime(
                e.startTime.year,
                e.startTime.month,
                e.startTime.day,
              ),
            )
            .toSet()
            .length;

    final progress = (days / 7).clamp(0, 1).toDouble();

    return Achievement(
      type: AchievementType.sevenDayStreak,
      title: "7‑Day Streak",
      description: "Track sleep for 7 different days",
      unlocked: days >= 7,
      progress: progress,
    );
  }

  static Achievement _perfectSleeper(List<SleepRecord> history, int goal) {
    final perfectNights =
        history.where((e) => e.durationMinutes >= goal * 60).length;

    final progress = (perfectNights / 5).clamp(0, 1).toDouble();

    return Achievement(
      type: AchievementType.perfectSleeper,
      title: "Perfect Sleeper",
      description: "Sleep at least your goal for 5 nights",
      unlocked: perfectNights >= 5,
      progress: progress,
    );
  }

  static Achievement _earlyRiser(List<SleepRecord> history) {
    final early = history.where((e) => e.endTime.hour < 7).length;

    final progress = (early / 3).clamp(0, 1).toDouble();

    return Achievement(
      type: AchievementType.earlyRiser,
      title: "Early Riser",
      description: "Wake up before 7 AM, 3 times",
      unlocked: early >= 3,
      progress: progress,
    );
  }

  static Achievement _nightOwl(List<SleepRecord> history) {
    final count = history.where((e) => e.startTime.hour <= 10).length;

    final progress = (count / 10).clamp(0, 1).toDouble();

    return Achievement(
      type: AchievementType.nightOwl,
      title: "Night Owl",
      description: "Sleep before 10 PM, 10 times",
      unlocked: count >= 10,
      progress: progress,
    );
  }

  static Achievement _consistentSleeper(List<SleepRecord> history) {
    if (history.length < 5) {
      return const Achievement(
        type: AchievementType.consistency,
        title: "Consistent Sleeper",
        description: "Maintain a consistent bedtime for 5 days",
        unlocked: false,
        progress: 0,
      );
    }

    final recent = history.take(5).toList();

    final baseMinutes =
        recent.first.startTime.hour * 60 + recent.first.startTime.minute;

    final consistent = recent.every((e) {
      int recordMinutes = e.startTime.hour * 60 + e.startTime.minute;

      int diff = (recordMinutes - baseMinutes).abs();
      if (diff > 720) {
        diff = 1440 - diff; 
      }

      return diff <= 30;
    });

    return Achievement(
      type: AchievementType.consistency,
      title: "Consistent Sleeper",
      description: "Maintain a consistent bedtime for 5 days",
      unlocked: consistent,
      progress: consistent ? 1 : 0.4,
    );
  }
}
