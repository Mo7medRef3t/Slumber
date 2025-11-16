// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';
import 'package:slumber/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:slumber/features/profile/presentation/views/widgets/profile_info_card.dart';
import 'package:slumber/features/profile/presentation/views/widgets/profile_options_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  SlumberUser? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = SlumberUser.fromMap(snapshot.data()!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          userData == null
              ? const Center(child: CircularProgressIndicator.adaptive())
              : SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    ProfileHeader(user: userData!),
                    SizedBox(height: 25.h),
                    ProfileInfoCard(user: userData!),
                    SizedBox(height: 20.h),
                    ProfileOptionsCard(
                      user: userData!,
                      onProfileUpdated: _fetchUserData,
                    ),
                  ],
                ),
              ),
    );
  }
}
