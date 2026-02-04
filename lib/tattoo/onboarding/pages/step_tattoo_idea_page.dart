import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepTattooIdeaPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepTattooIdeaPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;
    const int maxCharacters = 500;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scrollable content — prevents overflow when keyboard opens
            Flexible(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OnboardingHeader(currentStep: 4, onBack: onBack),
                    SizedBox(height: 28.h),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.stepTattooIdeaWhatYourTattooIdea,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 150.h,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.titleGradientStart,
                            width: 1.w,
                          ),
                          color: cardBgColor,
                          gradient: cardGradient,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    maxLength: maxCharacters,
                                    maxLines: null,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(
                                        context,
                                      )!.stepTattooIdeaHint,
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textGrey,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 265.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            OnboardingNextButton(
              enabled: controller.text.trim().isNotEmpty,
              isLastStep: false,
              onPressed: onNext,
            ),
            SizedBox(height: 35.h),
          ],
        );
      },
    );
  }
}
