import 'package:equatable/equatable.dart';
import '../data/models/achievement.dart';

abstract class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => [];
}

class AchievementsInitial extends AchievementsState {}

class AchievementsLoaded extends AchievementsState {
  final List<Achievement> achievements;
  const AchievementsLoaded(this.achievements);

  @override
  List<Object?> get props => [achievements];
}

class AchievementUnlocked extends AchievementsState {
  final Achievement achievement;
  const AchievementUnlocked(this.achievement);

  @override
  List<Object?> get props => [achievement];
}
