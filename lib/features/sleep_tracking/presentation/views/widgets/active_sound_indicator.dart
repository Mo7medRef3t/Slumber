import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/features/relax/cubit/sound_cubit.dart';
import 'package:slumber/features/relax/cubit/sound_state.dart';

class ActiveSoundIndicator extends StatelessWidget {
  final VoidCallback onTap;

  const ActiveSoundIndicator({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundCubit, SoundState>(
      builder: (context, state) {
        if (state is SoundIdle) return const SizedBox.shrink();

        final sound =
            state is SoundPlaying ? state.sound : (state as SoundPaused).sound;
        final isPlaying = state is SoundPlaying;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: sound.gradientColors),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPlaying ? Icons.music_note : Icons.music_off,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "${sound.title} ${isPlaying ? '♪' : '⏸'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
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
