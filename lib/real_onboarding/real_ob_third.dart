import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Real onboarding screen - Third screen (Final)
class RealOnboardingThirdScreen extends StatelessWidget {
  const RealOnboardingThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top illustration - smaller flex to move up
            Expanded(flex: 8, child: _buildTopSection(isDark)),
            // Keyboard section - more flex to move down
            Expanded(flex: 4, child: _buildKeyboardSection(isDark)),
            // Bottom section: Feature title, description - smaller flex
            Expanded(flex: 3, child: _buildBottomSection(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        // Flower bouquet illustration - bigger
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Image.asset(
            isDark
                ? 'assets/splash/third_one_dark.png'
                : 'assets/splash/third_one_light.png',
            fit: BoxFit.contain,
            height: 220,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.local_florist,
                size: 150,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              );
            },
          ),
        ),
        const SizedBox(height: 2),
        // Tattoo Maker title
        Text(
          'Tattoo Maker',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Keyboard image - moved down
          Expanded(
            child: Image.asset(
              isDark
                  ? 'assets/splash/third_two_dark.png'
                  : 'assets/splash/third_two_light.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Simple placeholder if image doesn't exist
                return Center(
                  child: Icon(
                    Icons.keyboard,
                    size: 100,
                    color: isDark ? AppColors.textGrey : AppColors.textGrey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Feature title
          Text(
            'Flower Creation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Turn your name into a beautiful\nflower-inspired design.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.textGrey : AppColors.textPrimary,
                fontFamily: 'Amaranth',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
