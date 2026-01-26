import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
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
    // Force light theme for onboarding (one-time flow)
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
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
                  _buildBottomNavigation(),
                ],
              ),
            ),
            // Skip button (only show on first two pages) - Stack on top
            if (_currentPage < 2)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: _currentPage == 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: TextButton(
                              onPressed: _onSkip,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.skip,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Amaranth',
                                ),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: _onSkip,
                            child: Text(
                              AppLocalizations.of(context)!.skip,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                                fontFamily: 'Amaranth',
                              ),
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
              ),
              child: Text(
                _currentPage == 2
                    ? AppLocalizations.of(context)!.start
                    : AppLocalizations.of(context)!.continue_,
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
          _buildPaginationDots(),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
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
                : AppColors.textGrey.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }
}

/// First onboarding screen with onboarding_one.png
class _FirstOnboardingScreen extends StatelessWidget {
  const _FirstOnboardingScreen();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image - full cover
        Positioned.fill(
          child: Image.asset(
            'assets/splash/onboarding_one.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: AppColors.lightBackground);
            },
          ),
        ),
        // Gradient fade to white at bottom
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.lightBackground.withValues(alpha: 0.5),
                  AppColors.lightBackground,
                ],
                stops: const [0.0, 0.5, 0.7, 1.0],
              ),
            ),
          ),
        ),
        // Content at bottom - simple positioning
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Center(
                    child: Text(
                      'Tattoo Creation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
                    'Create unique tattoo designs and see how they look on your hand in real time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
