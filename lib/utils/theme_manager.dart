import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeManager {
  static const String _fontFamily = 'Amaranth';

  /// Returns the dark mode background gradient decoration
  static BoxDecoration get darkModeBackgroundGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.gradientBlack, // Black at top
          AppColors.gradientCenter, // Center #2D3136 with opacity
          AppColors.gradientBlack, // Black at bottom
        ],
        stops: [0.35, 0.5, 0.95],
      ),
    );
  }

  /// Returns the light mode background (white)
  static BoxDecoration get lightModeBackground {
    return const BoxDecoration(
      color: AppColors.lightBackground,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySeed,
        brightness: Brightness.light,
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: const TextTheme().apply(fontFamily: _fontFamily),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySeed,
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: const TextTheme().apply(fontFamily: _fontFamily),
    );
  }
}
