import 'dart:async';
import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'home_shell.dart';
import 'real_onboarding/real_onboarding_flow.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkTheme;

  const SplashScreen({super.key, this.isDarkTheme = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RealOnboardingFlow()),
        );
      }
    });
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
            child: FractionallySizedBox(
              widthFactor: 0.7,
              heightFactor: 0.7,
              child: Image.asset(
                widget.isDarkTheme
                    ? 'assets/splash_black.png'
                    : 'assets/splash_white.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
