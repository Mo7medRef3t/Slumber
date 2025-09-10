import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/widgets/custom_fields.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/crescent.png", height: 95.h),
          Text(
            "Welcome Back",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 8.h),
          Text(
            "Sign in to continue",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 40.h),

          /// Email Field
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
          SizedBox(height: 30.h),

          /// Sign In Button
          ElevatedButton(
            onPressed: () {
              // TODO: Add login logic
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Text("Sign In", style: TextStyle(fontSize: 16.sp)),
          ),
          SizedBox(height: 16.h),

          /// Go to Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () => context.go(AppRouter.kSignUp),
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
