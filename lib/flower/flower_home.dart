import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../widgets/inkvision_underline.dart';

class FlowerHome extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const FlowerHome({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        decoration: isDark
            ? ThemeManager.darkModeBackgroundGradient
            : ThemeManager.lightModeBackground,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Header: menu + InkVision + notification
              _buildHeader(context, isDark: isDark),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Input image centered
                    _buildInputImage(),
                    const SizedBox(height: 20),
                    // Welcome text
                    _buildWelcomeText(isDark),
                  ],
                ),
              ),
              // Create button - little above navbar
              _buildCreateButton(context, isDark),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isDark}) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final buttonBgColor = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/one.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor),
            ),
            onPressed: onMenuTap,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'InkVision',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textWhite
                      : AppColors.darkBackground,
                  fontFamily: 'Amaranth',
                ),
              ),
              const SizedBox(height: 6),
              const InkVisionUnderline(width: 120, height: 3),
            ],
          ),
        ),
        // Notification button
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/two.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) =>
                  Icon(Icons.notifications_outlined, color: iconColor),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildInputImage() {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Image.asset(
        'assets/flower/input.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 330,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardGradientStart.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.textGrey,
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeText(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Transform your name',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'into a bouquet tattoo',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to flower creation flow
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Create',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
