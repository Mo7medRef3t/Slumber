import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/sound_model.dart';
import 'sound_state.dart';

class SoundCubit extends Cubit<SoundState> {
  final AudioPlayer _player = AudioPlayer();
  Timer? _sleepTimer;

  SoundCubit() : super(SoundIdle()) {
    // Loop تلقائي: الصوت يتكرر للأبد
    _player.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> toggleSound(SoundModel sound) async {
    final currentState = state;

    if (currentState is SoundPlaying && currentState.sound.id == sound.id) {
      await _player.pause();
      emit(SoundPaused(sound: sound, timerMinutes: currentState.timerMinutes));
      return;
    }

    if (currentState is SoundPaused && currentState.sound.id == sound.id) {
      await _player.resume();
      emit(SoundPlaying(sound: sound, timerMinutes: currentState.timerMinutes));
      return;
    }

    await _player.stop();
    await _player.play(AssetSource(sound.audioPath));
    emit(SoundPlaying(sound: sound));

    debugPrint("🎵 Playing: ${sound.title} (Looping)");
  }

  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();

    final currentState = state;
    SoundModel? currentSound;

    if (currentState is SoundPlaying) {
      currentSound = currentState.sound;
      emit(SoundPlaying(sound: currentSound, timerMinutes: minutes));
    } else if (currentState is SoundPaused) {
      currentSound = currentState.sound;
      emit(SoundPaused(sound: currentSound, timerMinutes: minutes));
    }

    _sleepTimer = Timer(Duration(minutes: minutes), () {
      stopSound();
      debugPrint("⏱️ Timer ended. Sound stopped.");
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();

    final currentState = state;
    if (currentState is SoundPlaying) {
      emit(SoundPlaying(sound: currentState.sound, timerMinutes: null));
    } else if (currentState is SoundPaused) {
      emit(SoundPaused(sound: currentState.sound, timerMinutes: null));
    }
  }

  Future<void> stopSound() async {
    _sleepTimer?.cancel();
    await _player.stop();
    emit(SoundIdle());
  }

  @override
  Future<void> close() {
    _sleepTimer?.cancel();
    _player.dispose();
    return super.close();
  }
}
