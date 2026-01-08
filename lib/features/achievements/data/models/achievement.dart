enum AchievementType {
  firstSleep,
  sevenDayStreak,
  perfectSleeper,
  earlyRiser,
  consistency,
  nightOwl,
}

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final bool unlocked;
  final double progress; // 0 → 1
  final bool justUnlocked;
  const Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.progress,
    this.justUnlocked = false,
  });

  Achievement copyWith({bool? unlocked, double? progress, bool? justUnlocked}) {
    return Achievement(
      type: type,
      title: title,
      description: description,
      unlocked: unlocked ?? this.unlocked,
      progress: progress ?? this.progress,
      justUnlocked: justUnlocked ?? false,
    );
  }
}
