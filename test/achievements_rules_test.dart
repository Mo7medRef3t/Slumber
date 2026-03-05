import 'package:flutter_test/flutter_test.dart';
import 'package:slumber/features/achievements/data/achievements_rules.dart';
import 'package:slumber/features/achievements/data/models/achievement.dart';
import 'package:slumber/features/sleep/models/sleep_record.dart';

void main() {
  SleepRecord makeRecord({
    required DateTime start,
    required int durationMinutes,
  }) {
    return SleepRecord(
      id: start.toIso8601String(),
      startTime: start,
      endTime: start.add(Duration(minutes: durationMinutes)),
      durationMinutes: durationMinutes,
    );
  }

  group('AchievementsRules', () {
    group('First Sleep', () {
      test('should be locked when no history', () {
        final achievements = AchievementsRules.evaluate([], 8);
        final firstSleep = achievements.firstWhere(
          (a) => a.type == AchievementType.firstSleep,
        );

        expect(firstSleep.unlocked, isFalse);
        expect(firstSleep.progress, equals(0));
      });

      test('should unlock with one record', () {
        final history = [
          makeRecord(start: DateTime(2026, 1, 18, 22, 0), durationMinutes: 480),
        ];

        final achievements = AchievementsRules.evaluate(history, 8);
        final firstSleep = achievements.firstWhere(
          (a) => a.type == AchievementType.firstSleep,
        );

        expect(firstSleep.unlocked, isTrue);
        expect(firstSleep.progress, equals(1.0));
      });
    });

    group('7-Day Streak', () {
      test('should be locked with less than 7 days', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final streak = achievements.firstWhere(
          (a) => a.type == AchievementType.sevenDayStreak,
        );

        expect(streak.unlocked, isFalse);
        expect(streak.progress, closeTo(3 / 7, 0.01));
      });

      test('should unlock with 7 different days', () {
        final history = List.generate(
          7,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final streak = achievements.firstWhere(
          (a) => a.type == AchievementType.sevenDayStreak,
        );

        expect(streak.unlocked, isTrue);
        expect(streak.progress, equals(1.0));
      });

      test('duplicate days should count as one', () {
        final history = [
          makeRecord(start: DateTime(2026, 1, 18, 22, 0), durationMinutes: 240),
          makeRecord(start: DateTime(2026, 1, 18, 14, 0), durationMinutes: 60),
        ];

        final achievements = AchievementsRules.evaluate(history, 8);
        final streak = achievements.firstWhere(
          (a) => a.type == AchievementType.sevenDayStreak,
        );

        expect(streak.progress, closeTo(1 / 7, 0.01));
      });
    });

    group('Perfect Sleeper', () {
      test('should be locked with no goal-meeting nights', () {
        final history = [
          makeRecord(
            start: DateTime(2026, 1, 18, 22, 0),
            durationMinutes: 300, // 5 hours (أقل من 8)
          ),
        ];

        final achievements = AchievementsRules.evaluate(history, 8);
        final perfect = achievements.firstWhere(
          (a) => a.type == AchievementType.perfectSleeper,
        );

        expect(perfect.unlocked, isFalse);
      });

      test('should unlock with 5 nights meeting goal', () {
        final history = List.generate(
          5,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480, // 8 hours = goal
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final perfect = achievements.firstWhere(
          (a) => a.type == AchievementType.perfectSleeper,
        );

        expect(perfect.unlocked, isTrue);
        expect(perfect.progress, equals(1.0));
      });

      test('progress should reflect partial completion', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final perfect = achievements.firstWhere(
          (a) => a.type == AchievementType.perfectSleeper,
        );

        expect(perfect.unlocked, isFalse);
        expect(perfect.progress, closeTo(3 / 5, 0.01));
      });
    });

    group('Early Riser', () {
      test('should unlock when waking before 7 AM three times', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480, // endTime = 6 AM
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final earlyRiser = achievements.firstWhere(
          (a) => a.type == AchievementType.earlyRiser,
        );

        expect(earlyRiser.unlocked, isTrue);
      });

      test('should be locked when waking after 7 AM', () {
        final history = [
          makeRecord(
            start: DateTime(2026, 1, 18, 23, 0),
            durationMinutes: 540, // endTime = 8 AM
          ),
        ];

        final achievements = AchievementsRules.evaluate(history, 8);
        final earlyRiser = achievements.firstWhere(
          (a) => a.type == AchievementType.earlyRiser,
        );

        expect(earlyRiser.unlocked, isFalse);
      });
    });

    group('Night Owl', () {
      test('should be locked with few early bedtimes', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 9, 0), // 9 AM
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final nightOwl = achievements.firstWhere(
          (a) => a.type == AchievementType.nightOwl,
        );

        expect(nightOwl.unlocked, isFalse);
      });

      test('should unlock with 10 early bedtimes', () {
        final history = List.generate(
          10,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 9, 0), // before 10 AM
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final nightOwl = achievements.firstWhere(
          (a) => a.type == AchievementType.nightOwl,
        );

        expect(nightOwl.unlocked, isTrue);
      });
    });

    group('Consistent Sleeper', () {
      test('should be locked with less than 5 records', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final consistent = achievements.firstWhere(
          (a) => a.type == AchievementType.consistency,
        );

        expect(consistent.unlocked, isFalse);
        expect(consistent.progress, equals(0));
      });

      test('should unlock with consistent bedtimes', () {
        final history = List.generate(
          5,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);
        final consistent = achievements.firstWhere(
          (a) => a.type == AchievementType.consistency,
        );

        expect(consistent.unlocked, isTrue);
      });

      test('should be locked with inconsistent bedtimes', () {
        final history = [
          makeRecord(start: DateTime(2026, 1, 18, 22, 0), durationMinutes: 480),
          makeRecord(start: DateTime(2026, 1, 17, 1, 0), durationMinutes: 480),
          makeRecord(start: DateTime(2026, 1, 16, 22, 0), durationMinutes: 480),
          makeRecord(start: DateTime(2026, 1, 15, 3, 0), durationMinutes: 480),
          makeRecord(start: DateTime(2026, 1, 14, 22, 0), durationMinutes: 480),
        ];

        final achievements = AchievementsRules.evaluate(history, 8);
        final consistent = achievements.firstWhere(
          (a) => a.type == AchievementType.consistency,
        );

        expect(consistent.unlocked, isFalse);
      });
    });

    group('General', () {
      test('evaluate should always return 6 achievements', () {
        final achievements = AchievementsRules.evaluate([], 8);
        expect(achievements.length, equals(6));
      });

      test('all achievements locked with empty history', () {
        final achievements = AchievementsRules.evaluate([], 8);

        for (final a in achievements) {
          expect(a.unlocked, isFalse, reason: '${a.title} should be locked');
        }
      });

      test('progress should always be between 0 and 1', () {
        final history = List.generate(
          3,
          (i) => makeRecord(
            start: DateTime(2026, 1, 18 - i, 22, 0),
            durationMinutes: 480,
          ),
        );

        final achievements = AchievementsRules.evaluate(history, 8);

        for (final a in achievements) {
          expect(a.progress, greaterThanOrEqualTo(0));
          expect(a.progress, lessThanOrEqualTo(1));
        }
      });
    });
  });
}
