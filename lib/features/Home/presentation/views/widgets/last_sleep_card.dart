import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import 'empty_state_box.dart';

class LastSleepCard extends StatelessWidget {
  const LastSleepCard({super.key});

  String _format(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return "${h}h ${m.toString().padLeft(2, '0')}m";
  }

  String _time(DateTime d) => DateFormat('hh:mm a').format(d);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        if (state is! SleepLoaded || state.lastSleep == null) {
          return const EmptyStateBox(message: "No recent sleep records yet.");
        }

        final last = state.lastSleep!;
        return Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.bedtime_rounded),
            title: Text("Last Sleep: ${_format(last.durationMinutes)}"),
            subtitle: Text("${_time(last.startTime)} - ${_time(last.endTime)}"),
          ),
        );
      },
    );
  }
}
