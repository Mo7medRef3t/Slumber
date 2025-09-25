import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/assets.dart';
import 'package:slumber/core/widgets/custom_fields.dart';
import 'package:slumber/features/auth/data/auth_service.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _authService = AuthService();
  bool _loading = false;

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.red),
    );
  }

  Future<void> _signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack("⚠️ Please fill all fields");
      return;
    }

    setState(() => _loading = true);
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        _showSnack("✅ Welcome back!", color: Colors.green);
        context.go('/home'); // بعد تسجيل الدخول يروح للهوم
      }
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _showSnack("✅ Signed in with Google", color: Colors.green);
        context.go('/home');
      }
    } catch (e) {
      _showSnack("Google Sign-In Failed: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
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

          ElevatedButton(
            onPressed: _loading ? null : _signIn,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            child: _loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text("Sign In", style: TextStyle(fontSize: 16.sp)),
          ),
          SizedBox(height: 16.h),

          Row(
            children: [
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "OR",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
            ],
          ),
          SizedBox(height: 16.h),

          InkWell(
            onTap: _loading ? null : _signInWithGoogle,
            child: CircleAvatar(
              radius: 25.h,
              backgroundColor:
                  brightness == Brightness.dark ? Colors.white : Colors.black12,
              child: Image.asset(
                AssetsData.google,
                height: 25.h,
                width: 25.h,
              ),
            ),
          ),
          SizedBox(height: 20.h),

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