import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:slumber/core/utils/app_colors.dart';
import 'package:slumber/core/utils/app_router.dart';

class OnBordingBody extends StatefulWidget {
  const OnBordingBody({super.key});

  @override
  State<OnBordingBody> createState() => _OnBordingBodyState();
}

class _OnBordingBodyState extends State<OnBordingBody> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  final List<_OnBordingData> _pages = [
    _OnBordingData(
      title: "Welcome to Slumber",
      description: "Your personal companion for better sleep and relaxation.",
    ),
    _OnBordingData(
      title: "Track & Improve Your Sleep",
      description: "Monitor your sleep patterns, set goals, and build healthier habits with ease.",
    ),
    _OnBordingData(
      title: "Relax. Sleep. Wake up refreshed.",
      description: "Start your journey today and enjoy a personalized experience tailored to your lifestyle.",
    ),
    
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.dark ? AppColors.dark : AppColors.light;

    final String imagePath =
        brightness == Brightness.dark ? "assets/images/darkSleep.png" : "assets/images/lightSleep.png";

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(imagePath, height: 220.h),

                    SizedBox(height: 40.h),

                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                    ),

                    SizedBox(height: 12.h),

                    /// الوصف
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: colors.secondaryText,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🔵 Dots Indicators
              Row(
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    height: 8.h,
                    width: _currentPage == index ? 20.w : 8.w,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? colors.primary
                          : colors.secondaryText,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

              /// زرار Next / Get Started
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  foregroundColor: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ✅ Data Model خاص بالـ Onboarding
class _OnBordingData {
  final String title;
  final String description;

  _OnBordingData({
    required this.title,
    required this.description,
  });
}