import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slumber/features/achievements/cubit/achievements_cubit.dart';
import 'package:slumber/features/achievements/cubit/achievements_state.dart';
import 'package:slumber/features/achievements/data/models/achievement.dart';
import 'package:slumber/features/achievements/presentation/views/widgets/achievement_card.dart';
import 'package:slumber/features/achievements/presentation/views/widgets/achievement_unlocked_dialog.dart';

class AchievementsView extends StatelessWidget {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        centerTitle: true,
      ),
      body: BlocListener<AchievementsCubit, AchievementsState>(
        listenWhen: (previous, current) =>
            current is AchievementsLoaded,
        listener: (context, state) {
          if (state is AchievementsLoaded) {
            final unlocked = state.achievements.firstWhere(
              (a) => a.justUnlocked,
              orElse: () => const Achievement(
                type: AchievementType.firstSleep,
                title: '',
                description: '',
                unlocked: false,
                progress: 0,
              ),
            );

            if (unlocked.justUnlocked) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AchievementUnlockedDialog(
                  achievement: unlocked,
                ),
              );
            }
          }
        },
        child: BlocBuilder<AchievementsCubit, AchievementsState>(
          builder: (context, state) {
            if (state is! AchievementsLoaded) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: state.achievements.length,
              itemBuilder: (context, index) {
                return AchievementCard(
                  achievement: state.achievements[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}