import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slumber/features/sleep/cubit/sleep_cubit.dart';
import 'package:slumber/features/sleep/cubit/sleep_state.dart';

class SleepHistoryView extends StatelessWidget {
  const SleepHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Logs"), centerTitle: true),
      body: BlocBuilder<SleepCubit, SleepState>(
        builder: (context, state) {
          if (state is! SleepLoaded || state.history.isEmpty) {
            return const Center(child: Text("No sleep records found."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.history.length,
            separatorBuilder: (_, __) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final record = state.history[index];
              final dateStr = DateFormat(
                'EEEE, MMM d',
              ).format(record.startTime);
              final startStr = DateFormat('h:mm a').format(record.startTime);
              final endStr = DateFormat('h:mm a').format(record.endTime);
              final durationH = record.durationMinutes ~/ 60;
              final durationM = record.durationMinutes % 60;

              return Dismissible(
                key: Key(record.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                // 🔥 التأكيد قبل الحذف
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Record?"),
                        content: const Text(
                          "Are you sure you want to delete this sleep log? This cannot be undone.",
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        actions: [
                          TextButton(
                            onPressed:
                                () => Navigator.of(
                                  context,
                                ).pop(false), // ❌ لا تمسح
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed:
                                () => Navigator.of(context).pop(true), // ✅ امسح
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },

                // 🔥 2. لو اليوزر داس Delete (رجع true)، الكود ده هيشتغل
                onDismissed: (direction) {
                  context.read<SleepCubit>().deleteRecord(record.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Record deleted"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    dateStr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("$startStr - $endStr"),
                  trailing: Text(
                    "${durationH}h ${durationM}m",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
