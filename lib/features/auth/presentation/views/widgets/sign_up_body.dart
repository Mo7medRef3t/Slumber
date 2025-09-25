import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slumber/core/utils/app_router.dart';
import 'package:slumber/core/utils/assets.dart';
import 'package:slumber/core/widgets/custom_fields.dart';
import 'package:slumber/features/auth/data/auth_service.dart';

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
  final TextEditingController ageController = TextEditingController();

  bool _loading = false;
  final _authService = AuthService();

  void _showSnack(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color ?? Colors.red),
    );
  }

  Future<void> _signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();
    final ageText = ageController.text.trim();

    final int? age = int.tryParse(ageText);

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPass.isEmpty ||
        age == null) {
      _showSnack("⚠️ Please fill all fields correctly");
      return;
    }

    if (password != confirmPass) {
      _showSnack("❌ Passwords do not match");
      return;
    }

    if (age <= 0 ) {
      _showSnack("⚠️ Age must be greater than 0");
      return;
    }
    if (age > 100) {
      _showSnack("⚠️ Enter Correct Age");
      return;
    }

    setState(() => _loading = true);
    try {
      final user = await _authService.signUp(email, password, name, age: age);
      if (user != null) {
        _showSnack("✅ Account created successfully!", color: Colors.green);
        context.go('/home');
      }
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _signUpWithGoogle() async {
    setState(() => _loading = true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        _showSnack(
          "✅ Signed up with Google successfully!",
          color: Colors.green,
        );
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
              isPassword: true,
            ),
            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    label: "Confirm Password",
                    hint: "Confirm Your Password",
                    controller: confirmPasswordController,
                    isPassword: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    label: "Age",
                    hint: "Enter Your Age",
                    controller: ageController,
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // ✅ يقبل أرقام فقط
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),

            ElevatedButton(
              onPressed: _loading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Sign Up", style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                const Expanded(
                  child: Divider(color: Colors.grey, thickness: 1),
                ),
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
                const Expanded(
                  child: Divider(color: Colors.grey, thickness: 1),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            InkWell(
              onTap: _loading ? null : _signUpWithGoogle,
              child: CircleAvatar(
                radius: 25.h,
                backgroundColor:
                    brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black12,
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
