import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slumber/core/firestore_service.dart';
import 'empty_state_box.dart';

class LastSleepCard extends StatelessWidget {
  const LastSleepCard({super.key});
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  String _formatTime12(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.getSleepHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyStateBox(message: "No recent sleep records yet.");
        }
        final last = snapshot.data!.first;
        final duration = _formatDuration(last["duration"]);
        final start = DateTime.parse(last["startTime"]);
        final end = DateTime.parse(last["endTime"]);
        final timeRange = "${_formatTime12(start)} - ${_formatTime12(end)}";

        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.bedtime_rounded),
            title: Text("Last Sleep: $duration"),
            subtitle: Text(timeRange),
          ),
        );
      },
    );
  }
}
