import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';
import 'empty_state_box.dart';

class BestSleepCard extends StatelessWidget {
  const BestSleepCard({super.key});

  String _format(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return "${h}h ${m.toString().padLeft(2, '0')}m";
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        if (state is! SleepLoaded) return const SizedBox();

        final best = state.bestSleep;
        if (best == null) {
          return const EmptyStateBox(message: "No best sleep data yet.");
        }

        return Card(
          elevation: 20,
          color: colors.primary.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text("Best Sleep Day"),
            subtitle: Text(
              "${DateFormat('EEE, MMM d').format(best.startTime)} • ${_format(best.durationMinutes)}",
            ),
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
