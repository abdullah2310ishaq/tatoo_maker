import 'dart:async';
import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'language/first_language.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkTheme;

  const SplashScreen({super.key, this.isDarkTheme = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _introController.forward();

    _checkOnboardingStatus();
  }

  // Legacy onboarding flow kept for later reuse.
  // Uncomment this method body (and restore needed imports)
  // when you want to go back to the original logic.
  /*
  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;

      if (!mounted) return;

      if (isOnboardingCompleted) {
        // User has completed onboarding, go directly to home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeShell()),
        );
      } else {
        // First time - go to language selection
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstLanguageScreen()),
        );
      }
    } catch (e) {
      // On error, assume first time and go to language selection
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstLanguageScreen()),
        );
      }
    }
  }
  */

  Future<void> _checkOnboardingStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const FirstLanguageScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.isDarkTheme
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: widget.isDarkTheme
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkSplashStart, // #000000 at 8.17%
                      AppColors.darkSplashEnd.withOpacity(
                        0.0,
                      ), // rgba(45, 49, 54, 0) at 87.03%
                    ],
                    stops: const [0.0817, 0.8703],
                  )
                : null,
            color: widget.isDarkTheme ? null : AppColors.lightBackground,
          ),
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: const _SplashTitle(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Text(
      'AI Tattoo',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        letterSpacing: 2,
        color: isDarkTheme ? AppColors.lightPrimary : AppColors.darkSecondary,
      ),
    );
  }
}
