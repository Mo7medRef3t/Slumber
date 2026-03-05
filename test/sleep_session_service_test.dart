import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slumber/core/services/sleep_session_service.dart';

void main() {
  group('SleepSessionService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('should have no active session initially', () async {
      final hasSession = await SleepSessionService.hasActiveSession();
      expect(hasSession, isFalse);
    });

    test('should return null when no session exists', () async {
      final session = await SleepSessionService.getActiveSession();
      expect(session, isNull);
    });

    test('should start a session successfully', () async {
      await SleepSessionService.startSession();

      final hasSession = await SleepSessionService.hasActiveSession();
      expect(hasSession, isTrue);
    });

    test('should return valid DateTime after starting', () async {
      final before = DateTime.now();
      await SleepSessionService.startSession();
      final after = DateTime.now();

      final session = await SleepSessionService.getActiveSession();

      expect(session, isNotNull);
      expect(
        session!.isAfter(before) || session.isAtSameMomentAs(before),
        isTrue,
      );
      expect(
        session.isBefore(after) || session.isAtSameMomentAs(after),
        isTrue,
      );
    });

    test('should end session successfully', () async {
      await SleepSessionService.startSession();

      expect(await SleepSessionService.hasActiveSession(), isTrue);

      await SleepSessionService.endSession();

      expect(await SleepSessionService.hasActiveSession(), isFalse);
      expect(await SleepSessionService.getActiveSession(), isNull);
    });

    test('ending non-existent session should not throw', () async {
      expect(
        () async => await SleepSessionService.endSession(),
        returnsNormally,
      );
    });

    test('starting new session should overwrite old one', () async {
      await SleepSessionService.startSession();
      final firstSession = await SleepSessionService.getActiveSession();

      await Future.delayed(const Duration(milliseconds: 100));

      await SleepSessionService.startSession();
      final secondSession = await SleepSessionService.getActiveSession();

      expect(secondSession!.isAfter(firstSession!), isTrue);
    });
  });
}
