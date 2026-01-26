import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'loading_screen.dart';

class ExploreDetailScreen extends StatelessWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;

  const ExploreDetailScreen({
    super.key,
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final promptTextColor = isDark ? Colors.white70 : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Column(
            children: [
              // Header: X icon on left, title centered
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 16.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Close icon on left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.close, color: iconColor, size: 28.sp),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    // Title centered
                    Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Asset image centered below X (smaller size)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      width:
                          MediaQuery.of(context).size.width *
                          0.6, // 60% of screen width
                      height: MediaQuery.of(context).size.width * 0.6,
                      child: _buildImageAsset(
                        context,
                        smallImagePath,
                        bigImagePath,
                        isDark,
                      ),
                    ),
                  ),
                ),
              ),
              // Prompt Detail Card (styled like homepage input card) - Bigger
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Prompt" label
                    Text(
                      'Prompt',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Prompt card with orange glow - Bigger
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height *
                            0.25, // At least 25% of screen height
                      ),
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.titleGradientStart,
                          width: 1.w,
                        ),
                        color: cardBgColor,
                        gradient: cardGradient,
                      ),
                      child: Stack(
                        children: [
                          // Orange glow in top-right corner (only in dark mode)
                          if (isDark)
                            Positioned(
                              top: -60.h,
                              right: -60.w,
                              child: IgnorePointer(
                                child: Container(
                                  width: 180.w,
                                  height: 180.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      center: Alignment.topRight,
                                      radius: 0.9,
                                      colors: [
                                        AppColors.cardGlowStart,
                                        AppColors.cardGlowEnd,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Prompt text
                          Text(
                            prompt,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: promptTextColor,
                              fontFamily: 'Amaranth',
                              height: 1.6,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // "Try This" button
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: bottomPadding > 0 ? bottomPadding : 20.h,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoadingScreen(
                            selectedStyleAsset: bigImagePath,
                            styleName: title,
                            promptText: prompt,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6541D), // Burnt orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8.r,
                        ), // Stadium shape
                      ),
                    ),
                    child: Text(
                      'Try This',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
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

  /// Builds the image asset, automatically using dark version in dark theme
  Widget _buildImageAsset(
    BuildContext context,
    String? smallImagePath,
    String bigImagePath,
    bool isDark,
  ) {
    if (smallImagePath == null) {
      return Image.asset(bigImagePath, fit: BoxFit.contain);
    }

    final String regularSmallPath = smallImagePath;

    if (isDark) {
      // Try dark versions first
      // Pattern 1: catsmall.png -> catsmalldark.png
      final String darkPath1 = regularSmallPath.replaceAllMapped(
        RegExp(r'(.+)(\.(png|jpg|jpeg))$'),
        (match) => '${match.group(1)}dark${match.group(2)}',
      );
      // Pattern 2: feathersmall.png -> feathersmall_dark.png
      final String darkPath2 = regularSmallPath.replaceAllMapped(
        RegExp(r'(.+)(\.(png|jpg|jpeg))$'),
        (match) => '${match.group(1)}_dark${match.group(2)}',
      );

      // Try dark version 1 first, then dark version 2, then regular small, then big
      return Image.asset(
        darkPath1,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            darkPath2,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                regularSmallPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(bigImagePath, fit: BoxFit.contain);
                },
              );
            },
          );
        },
      );
    } else {
      // Light theme: use regular small image or fallback to big
      return Image.asset(
        regularSmallPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(bigImagePath, fit: BoxFit.contain);
        },
      );
    }
  }
}
