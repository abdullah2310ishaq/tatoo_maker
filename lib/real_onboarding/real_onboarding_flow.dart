import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../home_shell.dart';
import 'real_ob_second.dart';
import 'real_ob_third.dart';
import 'real_ob_fourth.dart';

/// Main onboarding flow with PageView for swiping between screens
class RealOnboardingFlow extends StatefulWidget {
  const RealOnboardingFlow({super.key});

  @override
  State<RealOnboardingFlow> createState() => _RealOnboardingFlowState();
}

class _RealOnboardingFlowState extends State<RealOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      if (_currentPage >= 2) return; // last page: only proceed on Start tap
      if (!_pageController.hasClients) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onSkip() async {
    await _markOnboardingCompleted();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeShell()),
      );
    }
  }

  void _onContinue() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _markOnboardingCompleted();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeShell()),
        );
      }
    }
  }

  Future<void> _markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving onboarding status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force light theme for onboarding (one-time flow)
    // Force LTR so swipe direction is same as English in Arabic/RTL locales
    return Theme(
      data: ThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // PageView for swiping
              PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const ClampingScrollPhysics(),
                children: [
                  RealOnboardingSecondScreen(onNext: _onContinue),
                  RealOnboardingThirdScreen(onNext: _onContinue),
                  RealOnboardingFourthScreen(onNext: _onContinue),
                ],
              ),
              // Pagination dots overlaid at bottom (extra space above)
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildPaginationDots(),
                  ),
                ),
              ),
              // Skip button (only show on first two pages) - Stack on top
              if (_currentPage < 2)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
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
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Three-dot page indicator
  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? const Color(0xFFA6541D) // active orange
                : AppColors.textGrey.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}
