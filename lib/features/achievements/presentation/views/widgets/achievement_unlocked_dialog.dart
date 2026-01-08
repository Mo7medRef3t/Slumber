import 'package:flutter/material.dart';
import 'package:slumber/features/achievements/data/models/achievement.dart';

class AchievementUnlockedDialog extends StatefulWidget {
  final Achievement achievement;

  const AchievementUnlockedDialog({super.key, required this.achievement});

  @override
  State<AchievementUnlockedDialog> createState() =>
      _AchievementUnlockedDialogState();
}

class _AchievementUnlockedDialogState
    extends State<AchievementUnlockedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Trophy Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: scheme.primary,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Achievement Unlocked!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.achievement.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.achievement.description,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Awesome!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}