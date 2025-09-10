import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/widgets/custom_fields.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/crescent.png", height: 95.h),
            Text(
              "Create Account",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 8.h),
            Text(
              "Join us for better sleep habits",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 40.h),
            CustomTextField(
              label: "Full Name",
              hint: "Enter Your Name",
              controller: nameController,
            ),
            SizedBox(height: 20.h),
        
            CustomTextField(
              label: "Email",
              hint: "Enter Your Email",
              controller: emailController,
            ),
            SizedBox(height: 20.h),
        
            CustomTextField(
              label: "Password",
              hint: "Enter Your Password",
              controller: passwordController,
            ),
            SizedBox(height: 20.h),
        
            CustomTextField(
              label: "Confirm Password",
              hint: "Confirm Your Password",
              controller: confirmPasswordController,
            ),
            SizedBox(height: 30.h),
        
            ElevatedButton(
              onPressed: () {
                // TODO: Add signup logic
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text("Sign Up", style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 16.h),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => context.go(AppRouter.kSignIn),
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
