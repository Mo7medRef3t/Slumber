import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/relax/cubit/sound_cubit.dart';
import 'package:slumber/features/relax/cubit/sound_state.dart';
import 'package:slumber/features/relax/data/models/sound_model.dart';

class SoundTile extends StatelessWidget {
  final SoundModel sound;
  final bool isDark;

  const SoundTile({super.key, required this.sound, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundCubit, SoundState>(
      builder: (context, state) {
        final isPlaying = state is SoundPlaying && state.sound.id == sound.id;
        final isPaused = state is SoundPaused && state.sound.id == sound.id;
        final isActive = isPlaying || isPaused;

        return GestureDetector(
          onTap: () => context.read<SoundCubit>().toggleSound(sound),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient:
                  isActive
                      ? LinearGradient(
                        colors: sound.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                      : null,
              color:
                  isActive
                      ? null
                      : isDark
                      ? Colors.grey.shade800.withValues(alpha: 0.5)
                      : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border:
                  isActive
                      ? Border.all(color: Colors.white, width: 2)
                      : Border.all(
                        color:
                            isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                      ),
              boxShadow:
                  isPlaying
                      ? [
                        BoxShadow(
                          color: sound.gradientColors.last.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                      : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPlaying ? Icons.pause_circle_filled : sound.icon,
                  color:
                      isActive
                          ? Colors.white
                          : isDark
                          ? Colors.white70
                          : Colors.grey.shade600,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  sound.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isActive
                            ? Colors.white
                            : isDark
                            ? Colors.white70
                            : Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
                if (isPlaying)
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                      "Playing",
                      style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
