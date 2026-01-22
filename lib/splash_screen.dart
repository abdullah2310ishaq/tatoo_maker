import 'package:flutter/material.dart';
import 'utils/colors.dart';

class SplashScreen extends StatelessWidget {
  final bool isDarkTheme;

  const SplashScreen({super.key, this.isDarkTheme = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkTheme
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
          color: isDarkTheme ? null : AppColors.lightBackground,
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.7,
            heightFactor: 0.7,
            child: Image.asset(
              isDarkTheme
                  ? 'assets/splash_black.png'
                  : 'assets/splash_white.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
