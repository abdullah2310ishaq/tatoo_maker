import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tatoo_maker/services/admob_ids.dart';
import 'package:tatoo_maker/services/native_full_screen_ad_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../pro_access_screen.dart';
import '../utils/colors.dart';
import '../home_shell.dart';
import '../providers/usage_limit_provider.dart';
import '../services/remote_config_service.dart';
// import '../splash_pro.dart'; // Free-trial splash after onboarding (disabled).
import 'real_ob_second.dart';
import 'real_ob_third.dart';
import 'real_ob_fourth.dart';

/// Main onboarding flow — pages advance only via Continue / Start.
class RealOnboardingFlow extends StatefulWidget {
  const RealOnboardingFlow({super.key});

  @override
  State<RealOnboardingFlow> createState() => _RealOnboardingFlowState();
}

class _RealOnboardingFlowState extends State<RealOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Page index 1 = second onboarding screen (Moon Owl).
  static const int _secondOnboardingPageIndex = 1;

  /// Full-screen native shown after the second onboarding page (non-Pro).
  bool _showPostSecondOnboardingFullScreenNative = false;

  /// Page index 2 = third onboarding screen (try-on), after the native ad step.
  static const int _thirdOnboardingPageIndex = 2;

  bool _shouldShowOnboardingFullScreenNative() {
    if (context.read<UsageLimitProvider>().isProUnlocked) {
      return false;
    }
    return context.read<RemoteConfigService>().onboardingShowFullScreenNative;
  }

  int _onboardingStepCount() {
    return _shouldShowOnboardingFullScreenNative() ? 4 : 3;
  }

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

  void _onContinue() async {
    if (_showPostSecondOnboardingFullScreenNative) {
      setState(() {
        _showPostSecondOnboardingFullScreenNative = false;
        _currentPage = _thirdOnboardingPageIndex;
      });
      await _pageController.animateToPage(
        _thirdOnboardingPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (_currentPage == _secondOnboardingPageIndex) {
      if (_shouldShowOnboardingFullScreenNative()) {
        setState(() {
          _showPostSecondOnboardingFullScreenNative = true;
        });
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      return;
    }

    if (_currentPage < _thirdOnboardingPageIndex) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _markOnboardingCompleted();
      if (!mounted) return;
      await _routeAfterOnboarding();
    }
  }

  // static const String _prefsProSplashShownKey = 'pro_splash_shown_once';

  Future<void> _routeAfterOnboarding() async {
    if (!mounted) return;

    final usage = context.read<UsageLimitProvider>();
    final rc = context.read<RemoteConfigService>();
    final shouldShowPaywall = rc.splashShowPaywall;

    final Widget next;
    if (usage.isProUnlocked || !shouldShowPaywall) {
      next = const HomeShell();
    } else {
      // Direct full premium paywall (skip free-trial intro + trial paywall).
      next = Pro3DayAccessScreen(
        nextScreen: HomeShell(),
        showInterstitialOnClose: true,
        goToNextScreenOnClose: true,
      );
    }

    // Previously: first time showed [SplashProScreen] (free-trial intro), then paywall.
    // final prefs = await SharedPreferences.getInstance();
    // final proSplashShown = prefs.getBool(_prefsProSplashShownKey) ?? false;
    // if (proSplashShown) {
    //   next = ProAccessScreen(nextScreen: HomeShell());
    // } else {
    //   await prefs.setBool(_prefsProSplashShownKey, true);
    //   next = const SplashProScreen(nextScreen: HomeShell());
    // }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
    );
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
    // Force LTR so layout stays consistent in Arabic/RTL locales
    return Theme(
      data: ThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Offstage(
                offstage: _showPostSecondOnboardingFullScreenNative,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    RealOnboardingSecondScreen(),
                    RealOnboardingThirdScreen(),
                    RealOnboardingFourthScreen(),
                  ],
                ),
              ),
              if (_showPostSecondOnboardingFullScreenNative)
                _buildPostSecondOnboardingFullScreenNative(context),
              if (!_showPostSecondOnboardingFullScreenNative)
                _buildBottomActionArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionArea(BuildContext context) {
    final isLastPage = _currentPage == _thirdOnboardingPageIndex;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6541D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastPage
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
              SizedBox(height: 5.h),
              _buildPaginationDots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostSecondOnboardingFullScreenNative(BuildContext context) {
    return ColoredBox(
      color: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NativeFullScreenAdView(
                adUnitId: AdIds.testOnBoardingNativeId,
                isDark: true,
                backgroundColor: AppColors.darkBackground,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA6541D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.continue_,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  _buildPaginationDots(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _activePaginationIndex() {
    if (_showPostSecondOnboardingFullScreenNative) {
      return 2;
    }
    if (_currentPage == 0) return 0;
    if (_currentPage == 1) return 1;
    return _shouldShowOnboardingFullScreenNative() ? 3 : 2;
  }

  Widget _buildPaginationDots() {
    final activeIndex = _activePaginationIndex();
    final stepCount = _onboardingStepCount();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stepCount, (index) {
        final isActive = index == activeIndex;
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
