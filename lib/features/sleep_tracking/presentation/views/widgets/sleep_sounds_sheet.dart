import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/relax/cubit/sound_cubit.dart';
import 'package:slumber/features/relax/cubit/sound_state.dart';
import 'package:slumber/features/relax/data/models/sound_model.dart';
import 'sound_tile.dart';

class SleepSoundsSheet extends StatelessWidget {
  const SleepSoundsSheet({super.key});

  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<SoundCubit>(),
          child: _SheetContent(isDark: isDark),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _SheetContent extends StatelessWidget {
  final bool isDark;
  const _SheetContent({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(context, scheme),
              _buildTimerRow(context),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: SoundData.sounds.length,
                  itemBuilder: (context, index) {
                    return SoundTile(
                      sound: SoundData.sounds[index],
                      isDark: isDark,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Icon(Icons.music_note, color: scheme.primary),
          SizedBox(width: 8.w),
          Text(
            "Sleep Sounds",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          BlocBuilder<SoundCubit, SoundState>(
            builder: (context, state) {
              if (state is SoundIdle) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => context.read<SoundCubit>().stopSound(),
                icon: const Icon(Icons.stop, color: Colors.redAccent),
                label: const Text(
                  "Stop",
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerRow(BuildContext context) {
    return BlocBuilder<SoundCubit, SoundState>(
      builder: (context, state) {
        if (state is SoundIdle) return const SizedBox.shrink();

        int? activeTimer;
        if (state is SoundPlaying) activeTimer = state.timerMinutes;
        if (state is SoundPaused) activeTimer = state.timerMinutes;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                "Auto-stop: ",
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                  fontSize: 13.sp,
                ),
              ),
              _TimerChip(
                label: "15m",
                minutes: 15,
                activeTimer: activeTimer,
                isDark: isDark,
              ),
              SizedBox(width: 6.w),
              _TimerChip(
                label: "30m",
                minutes: 30,
                activeTimer: activeTimer,
                isDark: isDark,
              ),
              SizedBox(width: 6.w),
              _TimerChip(
                label: "60m",
                minutes: 60,
                activeTimer: activeTimer,
                isDark: isDark,
              ),
              if (activeTimer != null) ...[
                SizedBox(width: 6.w),
                ActionChip(
                  label: Text("Off", style: TextStyle(fontSize: 12.sp)),
                  onPressed:
                      () => context.read<SoundCubit>().cancelSleepTimer(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _TimerChip extends StatelessWidget {
  final String label;
  final int minutes;
  final int? activeTimer;
  final bool isDark;

  const _TimerChip({
    required this.label,
    required this.minutes,
    required this.activeTimer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeTimer == minutes;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color:
              isActive
                  ? Colors.white
                  : isDark
                  ? Colors.white70
                  : Colors.black87,
        ),
      ),
      selected: isActive,
      selectedColor: Theme.of(context).colorScheme.primary,
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      onSelected: (_) => context.read<SoundCubit>().setSleepTimer(minutes),
    );
  }
}
