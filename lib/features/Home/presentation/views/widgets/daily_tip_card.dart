import 'package:flutter/material.dart';

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.lightbulb, color: Colors.amber),
        title: const Text("Daily Sleep Tip"),
        subtitle: const Text(
          "Try to avoid caffeine 6 hours before bedtime for better sleep quality.",
        ),
      ),
    );
  }
}
