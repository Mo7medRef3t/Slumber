import 'package:equatable/equatable.dart';
import '../data/models/sound_model.dart';

abstract class SoundState extends Equatable {
  const SoundState();
  @override
  List<Object?> get props => [];
}

class SoundIdle extends SoundState {}

class SoundPlaying extends SoundState {
  final SoundModel sound;
  final int? timerMinutes;

  const SoundPlaying({required this.sound, this.timerMinutes});

  @override
  List<Object?> get props => [sound.id, timerMinutes];
}

class SoundPaused extends SoundState {
  final SoundModel sound;
  final int? timerMinutes;

  const SoundPaused({required this.sound, this.timerMinutes});

  @override
  List<Object?> get props => [sound.id, timerMinutes];
}
