import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/theme/theme_cubit.dart';

class ThemeModeCard extends StatelessWidget {
  const ThemeModeCard({super.key});

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
              "App Theme",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      activeColor: scheme.primary,
                      title: const Text("Light Mode"),
                      value: ThemeMode.light,
                      groupValue: mode,
                      onChanged: (v) => context.read<ThemeCubit>().setTheme(v!),
                    ),
                    RadioListTile<ThemeMode>(
                      activeColor: scheme.primary,
                      title: const Text("Dark Mode"),
                      value: ThemeMode.dark,
                      groupValue: mode,
                      onChanged: (v) => context.read<ThemeCubit>().setTheme(v!),
                    ),
                    RadioListTile<ThemeMode>(
                      activeColor: scheme.primary,
                      title: const Text("System Default"),
                      value: ThemeMode.system,
                      groupValue: mode,
                      onChanged: (v) => context.read<ThemeCubit>().setTheme(v!),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
