import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/colors.dart';
import '../models/onboarding_models.dart';
import '../widgets/onboarding_next_button.dart';

class ZodiacDisplayPage extends StatelessWidget {
  final ZodiacInfo zodiacInfo;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const ZodiacDisplayPage({
    super.key,
    required this.zodiacInfo,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Back button
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.buttonBackground
                : AppColors.textGrey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 20.sp,
            ),
            onPressed: onBack,
            padding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final imageSize = (availableHeight * 0.5).clamp(140.h, 200.h);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Zodiac graphic - image
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(
                      zodiacInfo.assetPath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardGradientStart.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.textGrey,
                              size: 48.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: (availableHeight * 0.05).clamp(12.h, 20.h)),
                  // Title - zodiac name
                  Text(
                    zodiacInfo.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  SizedBox(height: (availableHeight * 0.03).clamp(8.h, 12.h)),
                  // Date range
                  Text(
                    zodiacInfo.dateRange,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  SizedBox(height: (availableHeight * 0.08).clamp(16.h, 24.h)),
                  // Description - flexible to fit remaining space
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        zodiacInfo.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: isDark
                              ? AppColors.textGrey
                              : AppColors.textGrey.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        // Next button
        OnboardingNextButton(
          enabled: true,
          isLastStep: false,
          onPressed: onNext,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
