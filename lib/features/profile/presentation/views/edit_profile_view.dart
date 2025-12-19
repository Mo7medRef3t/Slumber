// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/core/utils/app_theme.dart';
import 'package:slumber/core/firestore_service.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  final _firestoreService = FirestoreService();

  bool _loading = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data();
          _nameController.text = userData!["name"] ?? "";
          _ageController.text = userData!["age"].toString();
          _goalController.text = userData!["sleepGoalHours"].toString();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load data: $e")));
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _loading = true);

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final updatedUser = SlumberUser(
        id: uid,
        email: userData!["email"],
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        sleepGoalHours: int.parse(_goalController.text.trim()),
      );

      await _firestoreService.updateUserProfile(updatedUser);
      context.read<UserCubit>().updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile updated successfully")),
      );
      // back to profile page
      if (mounted) {
        context.pop(true); // من GoRouter
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          userData == null
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      _buildField(
                        label: "Full Name",
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? "Enter your name"
                                    : null,
                      ),

                      SizedBox(height: 20.h),

                      // Age
                      _buildField(
                        label: "Age",
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Enter your age";
                          }
                          final age = int.tryParse(v);
                          if (age == null || age <= 0) return "Invalid age";
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Sleep Goal
                      _buildField(
                        label: "Sleep Goal (hours)",
                        controller: _goalController,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter goal hours";
                          final g = int.tryParse(v);
                          if (g == null || g <= 0) return "Invalid goal hours";
                          return null;
                        },
                      ),

                      SizedBox(height: 40.h),

                      // Save Changes button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loading ? null : _saveChanges,
                          icon: const Icon(Icons.save_outlined),
                          label:
                              _loading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text("Save Changes"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Cancel / Back button
                      OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        label: const Text("Cancel"),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: scheme.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 20.w,
                          ),
                          foregroundColor: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    final extra = Theme.of(context).extension<ExtraColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: extra.secondaryText,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}
