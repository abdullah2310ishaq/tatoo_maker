import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../home_shell.dart';
import 'real_ob.dart';
import 'real_ob_third.dart';

/// Main onboarding flow with PageView for swiping between screens
class RealOnboardingFlow extends StatefulWidget {
  const RealOnboardingFlow({super.key});

  @override
  State<RealOnboardingFlow> createState() => _RealOnboardingFlowState();
}

class _RealOnboardingFlowState extends State<RealOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeShell()),
    );
  }

  void _onContinue() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Stack(
        children: [
          // PageView for swiping
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      // First screen (placeholder - to be created)
                      _FirstOnboardingScreen(),
                      // Second screen
                      RealOnboardingScreen(),
                      // Third screen
                      RealOnboardingThirdScreen(),
                    ],
                  ),
                ),
                // Bottom navigation (Continue/Start button + pagination)
                _buildBottomNavigation(isDark),
              ],
            ),
          ),
          // Skip button (only show on first two pages) - Stack on top
          if (_currentPage < 2)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Continue/Start button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA6541D), // Burnt orange
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Text(
                _currentPage == 2 ? 'Start' : 'Continue',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Amaranth',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Pagination dots
          _buildPaginationDots(isDark),
        ],
      ),
    );
  }

  Widget _buildPaginationDots(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? const Color(0xFFA6541D) // Orange for active
                : (isDark
                      ? AppColors.textGrey.withValues(alpha: 0.3)
                      : AppColors.textGrey.withValues(alpha: 0.3)),
          ),
        );
      }),
    );
  }
}

/// First onboarding screen (placeholder - to be implemented)
class _FirstOnboardingScreen extends StatelessWidget {
  const _FirstOnboardingScreen();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Center(
        child: Text(
          'First Onboarding Screen\n(To be implemented)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
