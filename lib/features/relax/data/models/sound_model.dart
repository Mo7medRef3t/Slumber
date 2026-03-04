import 'package:flutter/material.dart';

class SoundModel {
  final String id;
  final String title;
  final IconData icon;
  final String audioPath;
  final List<Color> gradientColors;

  const SoundModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.audioPath,
    required this.gradientColors,
  });
}

class SoundData {
  static const List<SoundModel> sounds = [
    SoundModel(
      id: 'rain',
      title: 'Rain',
      icon: Icons.water_drop,
      audioPath: 'sounds/rain.mp3',
      gradientColors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    ),
    SoundModel(
      id: 'thunder',
      title: 'Thunder',
      icon: Icons.flash_on,
      audioPath: 'sounds/thunder.mp3',
      gradientColors: [Color(0xFF373B44), Color(0xFF4286f4)],
    ),
    SoundModel(
      id: 'ocean',
      title: 'Ocean',
      icon: Icons.waves,
      audioPath: 'sounds/ocean.mp3',
      gradientColors: [Color(0xFF000428), Color(0xFF004e92)],
    ),
    SoundModel(
      id: 'forest',
      title: 'Forest',
      icon: Icons.park,
      audioPath: 'sounds/forest.mp3',
      gradientColors: [Color(0xFF134E5E), Color(0xFF71B280)],
    ),
    SoundModel(
      id: 'river',
      title: 'River',
      icon: Icons.water,
      audioPath: 'sounds/river.mp3',
      gradientColors: [Color(0xFF1D4350), Color(0xFFA43931)],
    ),
    SoundModel(
      id: 'wind',
      title: 'Wind',
      icon: Icons.air,
      audioPath: 'sounds/wind.mp3',
      gradientColors: [Color(0xFF536976), Color(0xFF292E49)],
    ),
    SoundModel(
      id: 'birds',
      title: 'Birds',
      icon: Icons.flutter_dash,
      audioPath: 'sounds/birds.mp3',
      gradientColors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
    ),
    SoundModel(
      id: 'fireplace',
      title: 'Fireplace',
      icon: Icons.local_fire_department,
      audioPath: 'sounds/fireplace.mp3',
      gradientColors: [Color(0xFFB24592), Color(0xFFF15F79)],
    ),
    SoundModel(
      id: 'white_noise',
      title: 'White Noise',
      icon: Icons.graphic_eq,
      audioPath: 'sounds/white_noise.mp3',
      gradientColors: [Color(0xFF42275a), Color(0xFF734b6d)],
    ),
    SoundModel(
      id: 'fan',
      title: 'Fan',
      icon: Icons.mode_fan_off,
      audioPath: 'sounds/fan.mp3',
      gradientColors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
    ),
    SoundModel(
      id: 'clock',
      title: 'Clock',
      icon: Icons.schedule,
      audioPath: 'sounds/clock.mp3',
      gradientColors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
    ),
    SoundModel(
      id: 'cafe',
      title: 'Café',
      icon: Icons.coffee,
      audioPath: 'sounds/cafe.mp3',
      gradientColors: [Color(0xFF7B4397), Color(0xFFDC2430)],
    ),
  ];
}
