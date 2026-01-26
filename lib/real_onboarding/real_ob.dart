import 'package:flutter/material.dart';
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
                Expanded(child: _buildContent(isDark)),
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

  Widget _buildContent(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Spacer to push content to bottom
        const Spacer(flex: 3),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Center(
            child: Text(
              'Custom Creation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'Create custom designs and bring\nyour creative ideas to life.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textGrey : AppColors.textPrimary,
              fontFamily: 'Amaranth',
              height: 1.5,
            ),
          ),
        ),
        // Small gap before Continue button
        const SizedBox(height: 20),
      ],
    );
  }
}
