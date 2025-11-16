// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/features/auth/data/auth_service.dart';

class DeleteAccountCard extends StatelessWidget {
  const DeleteAccountCard({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
              "Are you sure you want to permanently delete your account? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final auth = AuthService();
      final user = auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      await auth.signOut();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully.")),
        );
        GoRouter.of(context).go(AppRouter.kSignUp);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete account: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account Management",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Delete Account",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("Permanently remove your account data."),
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
