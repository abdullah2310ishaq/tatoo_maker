import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';

/// Real onboarding screen - Second screen
class RealOnboardingScreen extends StatelessWidget {
  const RealOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Stack(
        children: [
          // Background image with fade to white
          _buildBackground(isDark),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Main content - starting from top
                Expanded(child: _buildContent(context, isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return Stack(
      children: [
        // Background image with butterfly - covering full screen
        Positioned.fill(
          child: Image.asset(
            isDark
                ? 'assets/splash/splash_two_dark.png'
                : 'assets/splash/splash_two_light.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image doesn't exist
              return Container(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
              );
            },
          ),
        ),
        // Gradient fade to white at bottom 30%
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  isDark
                      ? AppColors.darkBackground.withValues(alpha: 0.3)
                      : AppColors.lightBackground.withValues(alpha: 0.5),
                  isDark ? AppColors.darkBackground : AppColors.lightBackground,
                ],
                stops: const [0.0, 0.5, 0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Spacer to push content to bottom
        const Spacer(flex: 3),
        // Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.customCreation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            AppLocalizations.of(context)!.customCreationDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textGrey : AppColors.textPrimary,
              fontFamily: 'Amaranth',
              height: 1.5,
            ),
          ),
        ),
        // Small gap before Continue button
        SizedBox(height: 20.h),
      ],
    );
  }
}
