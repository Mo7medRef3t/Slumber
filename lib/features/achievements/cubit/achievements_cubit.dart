import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/features/achievements/data/models/achievement.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import '../data/achievements_rules.dart';
import 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final SleepCubit sleepCubit;
  final UserCubit userCubit;

  StreamSubscription? _sleepSub;
  StreamSubscription? _userSub;

  List<Achievement>? _previous;

  AchievementsCubit({required this.sleepCubit, required this.userCubit})
    : super(AchievementsInitial()) {
    // 1️⃣ نسمع للـ User والـ Sleep عشان أول ما تفتح يحمل علطول
    _sleepSub = sleepCubit.stream.listen((_) => _recalculate());
    _userSub = userCubit.stream.listen((_) => _recalculate());

    // نشغل الحسابات فورًا
    _recalculate();
  }

  void _recalculate() async {
    final user = userCubit.user;

    // لو اليوزر لسه محملش، منعملش حاجة (هيفضل loading لحظة)
    if (user == null) return;

    final sleepState = sleepCubit.state;
    List<Achievement> newAchievements;

    // 2️⃣ حل مشكلة "لازم تعمل sleep عشان تظهر"
    // لو مفيش داتا نوم، احسب الاتشيفمنتس برضه (هيبقوا كلهم مقفولين بس هيظهروا)
    if (sleepState is! SleepLoaded) {
      newAchievements = AchievementsRules.evaluate([], user.sleepGoalHours);
    } else {
      newAchievements = AchievementsRules.evaluate(
        sleepState.history,
        user.sleepGoalHours,
      );
    }

    // 3️⃣ حل مشكلة "Dialog بيختفي بسرعة"
    // المقارنة عشان نعرف مين جديد اتفتح
    if (_previous != null) {
      for (int i = 0; i < newAchievements.length; i++) {
        final old = _previous![i];
        final current = newAchievements[i];

        if (!old.unlocked && current.unlocked) {
          // ✅ التريك هنا: نستنى ثانية لحد ما Navigator.pop يخلص والشاشة تستقر
          await Future.delayed(const Duration(milliseconds: 600));

          if (isClosed) return; // أمان عشان لو قفلت التطبيق
          emit(AchievementUnlocked(current));
        }
      }
    }

    _previous = newAchievements;

    if (isClosed) return;
    emit(AchievementsLoaded(newAchievements));
  }

  @override
  Future<void> close() {
    _sleepSub?.cancel();
    _userSub?.cancel();
    return super.close();
  }
}
