import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepLocationPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepLocationPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final borderColor = const Color(0xFFFE8B3A);

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingHeader(currentStep: 3, onBack: onBack),
            SizedBox(height: 40.h),
            // Question
            Text(
              AppLocalizations.of(context)!.stepLocationWhereYouBorn,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            SizedBox(height: 30.h),
            // Input field
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.buttonBackground
                    : AppColors.lightCardBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderColor, width: 1.w),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.stepLocationHint,
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textGrey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const Spacer(),
            // Next button
            OnboardingNextButton(
              enabled: controller.text.trim().isNotEmpty,
              isLastStep: false,
              onPressed: onNext,
            ),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}
