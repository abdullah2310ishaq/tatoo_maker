import 'package:flutter/material.dart';

class AppColors {
  // Dark theme splash gradient colors
  static const Color darkSplashStart = Color(0xFF000000); // #000000
  static const Color darkSplashEnd = Color(0xFF2D3136); // rgba(45, 49, 54, 0)

  // Light theme colors
  static const Color lightBackground = Colors.white;
  static const Color lightPrimary = Color(0xFFFF6B35); // Orange
  static const Color lightSecondary = Color(0xFFFF8C42); // Light orange

  // Dark theme colors
  static const Color darkBackground = Colors.black;
  static const Color darkPrimary = Color(0xFFFF6B35); // Orange
  static const Color darkSecondary = Color(0xFFFF8C42); // Light orange

  // Theme seed color - Orange
  static const Color primarySeed = Color(0xFFFF6B35);

  // Navigation bar colors
  static const Color navBarBackground = Color(0xFF1A1A1A); // Dark charcoal
  static const Color navBarActive = Color(0xFFFF8C42); // Orange for active
  static const Color navBarInactive = Color(0xFF8E8E8E); // Gray for inactive

  // Home page colors
  static const Color titleGradientStart = Color(0xFFF88532); // Orange
  static const Color titleGradientEnd = Color(0xFF2D3136); // Dark gray
  static const Color cardGradientStart = Color(0xFF151411); // Dark
  static const Color cardGradientEnd = Color(0xFF1E1914); // Dark brown
  static const Color cardGlowStart = Color(0xFFF88532); // Orange
  static const Color cardGlowEnd = Color(
    0x001E1914,
  ); // Transparent (rgba(30, 25, 20, 0))
  static const Color buttonBackground = Color(0xFF1A1A1A); // Dark charcoal
  static const Color drawerDarkBackground = Color(
    0xFF1B1C1F,
  ); // Drawer dark background
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF8E8E8E);
  static const Color textPrimary = Color(
    0xFF565656,
  ); // #565656 for text in both themes
  static const Color lightCardBackground = Color(
    0xFFF5F5F5,
  ); // Light gray for cards in light theme

  // Background gradient colors
  static const Color gradientTop = Color(0xFF353A40); // #353A40
  static const Color gradientBottom = Color(0xFF121416); // #121416
  static const Color gradientCenter = Color(
    0xFF353A40,
  ); // #2D3136 with 30% opacity (darker)
  static const Color gradientBlack = Color(0xFF000000); // #000000
}
