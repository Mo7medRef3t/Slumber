import 'package:flutter/material.dart';
import 'package:slumber/core/utils/app_colors.dart';
import 'package:slumber/features/home/presentation/views/dashboard_view.dart';
import 'package:slumber/features/achievements_view.dart';
import 'package:slumber/features/profile/presentation/views/profile_view.dart';
import 'package:slumber/features/sleep_history_view.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardView(),   // 🏠
    SleepHistoryView(),// 📊
    AchievementsView(),// 🏆
    ProfileView(),     // 👤
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = brightness == Brightness.dark ? AppColors.dark : AppColors.light;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        backgroundColor: colors.background,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Achievements"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}