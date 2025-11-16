import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'empty_state_box.dart';

class BestSleepCard extends StatelessWidget {
  const BestSleepCard({super.key});

  Future<Map<String, dynamic>?> _getBestSleep() async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("sleepHistory")
            .orderBy("duration", descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) return null;
    return snapshot.docs.first.data();
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return FutureBuilder<Map<String, dynamic>?>(
      future: _getBestSleep(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final record = snapshot.data;
        if (record == null) {
          return const EmptyStateBox(message: "No best sleep data yet.");
        }

        final duration = _formatDuration(record["duration"]);
        final start = DateTime.parse(record["startTime"]);
        final formattedDate = DateFormat('EEE, MMM d').format(start);

        return Card(
          elevation: 20,
          color: colors.primary.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text("Best Sleep Day"),
            subtitle: Text("$formattedDate • $duration"),
            trailing: Text(
              "🌙 Excellent",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
