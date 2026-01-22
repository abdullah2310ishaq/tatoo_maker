import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeManager {
  static const String _fontFamily = 'Amaranth';

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
      textTheme: const TextTheme().apply(
        fontFamily: _fontFamily,
      ),
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
      textTheme: const TextTheme().apply(
        fontFamily: _fontFamily,
      ),
    );
  }
}
