import 'package:flutter_test/flutter_test.dart';
import 'package:slumber/features/sleep/data/sleep_score_calculator.dart';
import 'package:slumber/features/sleep/models/sleep_record.dart';

void main() {
  group('SleepScoreCalculator', () {
    // ===== Daily Score Tests =====
    group('calculateDailyScore', () {
      test('perfect sleep should score 90+', () {
        final record = SleepRecord(
          id: '1',
          startTime: DateTime(2026, 1, 18, 22, 0), // 10:00 PM
          endTime: DateTime(2026, 1, 19, 6, 0), // 6:00 AM
          durationMinutes: 480, // 8 hours
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, greaterThanOrEqualTo(90));
      });

      test('short sleep should score low', () {
        final record = SleepRecord(
          id: '2',
          startTime: DateTime(2026, 1, 18, 3, 0), // 3:00 AM
          endTime: DateTime(2026, 1, 18, 6, 0), // 6:00 AM
          durationMinutes: 180, // 3 hours
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, lessThan(50));
      });

      test('late bedtime should reduce consistency score', () {
        final record = SleepRecord(
          id: '3',
          startTime: DateTime(2026, 1, 18, 4, 0),
          endTime: DateTime(2026, 1, 18, 12, 0),
          durationMinutes: 480,
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, equals(75));
      });

      test('ideal bedtime (9 PM - 12 AM) gives full consistency', () {
        final record = SleepRecord(
          id: '4',
          startTime: DateTime(2026, 1, 18, 21, 0), // 9 PM
          endTime: DateTime(2026, 1, 19, 5, 0),
          durationMinutes: 480,
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, equals(100));
      });

      test('zero duration should score very low', () {
        final record = SleepRecord(
          id: '5',
          startTime: DateTime(2026, 1, 18, 22, 0),
          endTime: DateTime(2026, 1, 18, 22, 0),
          durationMinutes: 0,
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, lessThanOrEqualTo(30));
      });

      test('oversleeping should cap at goal', () {
        final record = SleepRecord(
          id: '6',
          startTime: DateTime(2026, 1, 18, 22, 0),
          endTime: DateTime(2026, 1, 19, 10, 0),
          durationMinutes: 720, // 12 hours
        );

        final score = SleepScoreCalculator.calculateDailyScore(record, 8);

        expect(score, equals(100));
      });
    });

    group('calculateAverageScore', () {
      test('empty history should return 0', () {
        final score = SleepScoreCalculator.calculateAverageScore([], 8);
        expect(score, equals(0));
      });

      test('single record should return its score', () {
        final records = [
          SleepRecord(
            id: '1',
            startTime: DateTime(2026, 1, 18, 22, 0),
            endTime: DateTime(2026, 1, 19, 6, 0),
            durationMinutes: 480,
          ),
        ];

        final score = SleepScoreCalculator.calculateAverageScore(records, 8);

        expect(score, greaterThan(0));
      });

      test('should only consider last 7 days', () {
        final records = List.generate(
          10,
          (i) => SleepRecord(
            id: '$i',
            startTime: DateTime(2026, 1, 18 - i, 22, 0),
            endTime: DateTime(2026, 1, 19 - i, 6, 0),
            durationMinutes: 480,
          ),
        );

        final score = SleepScoreCalculator.calculateAverageScore(records, 8);

        expect(score, greaterThan(0));
        expect(score, lessThanOrEqualTo(100));
      });

      test('consistent good sleep should score high', () {
        final records = List.generate(
          7,
          (i) => SleepRecord(
            id: '$i',
            startTime: DateTime(2026, 1, 18 - i, 22, 0), // 10 PM
            endTime: DateTime(2026, 1, 19 - i, 6, 0), // 6 AM
            durationMinutes: 480,
          ),
        );

        final score = SleepScoreCalculator.calculateAverageScore(records, 8);

        expect(score, greaterThanOrEqualTo(90));
      });
    });

    group('getSleepQuality', () {
      test('score 95 should be Excellent', () {
        expect(SleepScoreCalculator.getSleepQuality(95), contains('Excellent'));
      });

      test('score 80 should be Good', () {
        expect(SleepScoreCalculator.getSleepQuality(80), contains('Good'));
      });

      test('score 60 should be Fair', () {
        expect(SleepScoreCalculator.getSleepQuality(60), contains('Fair'));
      });

      test('score 30 should be Needs Care', () {
        expect(
          SleepScoreCalculator.getSleepQuality(30),
          contains('Needs Care'),
        );
      });

      test('edge case: score 90 should be Excellent', () {
        expect(SleepScoreCalculator.getSleepQuality(90), contains('Excellent'));
      });

      test('edge case: score 75 should be Good', () {
        expect(SleepScoreCalculator.getSleepQuality(75), contains('Good'));
      });

      test('edge case: score 50 should be Fair', () {
        expect(SleepScoreCalculator.getSleepQuality(50), contains('Fair'));
      });
    });
  });
}
