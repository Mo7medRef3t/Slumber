// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slumber/core/user/cubit/user_cubit.dart';
import 'package:slumber/core/user/cubit/user_state.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is UserLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  ProfileHeader(user: state.user),
                  SizedBox(height: 25.h),
                  ProfileInfoCard(user: state.user),
                  SizedBox(height: 20.h),
                  ProfileOptionsCard(
                    user: state.user,
                    onProfileUpdated: () {
                      // ✅ user already updated via cubit
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Failed to load profile"));
        },
      ),
    );
  }
}
