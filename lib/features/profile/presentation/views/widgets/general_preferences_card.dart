import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralPreferencesCard extends StatefulWidget {
  const GeneralPreferencesCard({super.key});

  @override
  State<GeneralPreferencesCard> createState() => _GeneralPreferencesCardState();
}

class _GeneralPreferencesCardState extends State<GeneralPreferencesCard> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Preferences",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            SwitchListTile(
              title: const Text("Notifications"),
              subtitle: const Text("Receive reminders and sleep tips"),
              activeColor: scheme.primary,
              value: notifications,
              onChanged: (v) => setState(() => notifications = v),
            ),
          ],
        ),
      ),
    );
  }
}
