import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';
import '../models/onboarding_models.dart';
import '../utils/zodiac_utils.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepStyleSelectionPage extends StatefulWidget {
  final int? selectedStyleIndex;
  final ValueChanged<int?> onStyleSelected;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepStyleSelectionPage({
    super.key,
    required this.selectedStyleIndex,
    required this.onStyleSelected,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepStyleSelectionPage> createState() => _StepStyleSelectionPageState();
}

class _StepStyleSelectionPageState extends State<StepStyleSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final styles = getTattooStyles(context, isDark);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingHeader(currentStep: 5, onBack: widget.onBack),
        SizedBox(height: 40.h),
        // Question
        Text(
          AppLocalizations.of(context)!.stepStylePickYourTitleStyle,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Amaranth',
          ),
        ),
        SizedBox(height: 30.h),
        // Style selection
        Expanded(
          child: SizedBox(
            height: 190.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: styles.length,
              separatorBuilder: (_, __) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final item = styles[index];
                final bool isSelected = widget.selectedStyleIndex == index;
                return _buildStyleCard(item, index, isSelected, isDark);
              },
            ),
          ),
        ),
        const Spacer(),
        // Next button
        OnboardingNextButton(
          enabled: widget.selectedStyleIndex != null,
          isLastStep: true,
          onPressed: widget.onNext,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildStyleCard(
    TattooStyleItem item,
    int index,
    bool isSelected,
    bool isDark,
  ) {
    final double width = isSelected ? 150.w : 130.w;
    final Color borderColor = isSelected
        ? const Color(0xFFFE8B3A)
        : AppColors.cardGradientEnd;
    final cardBgColor = isDark
        ? const Color(0xFF151411)
        : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.4.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          widget.onStyleSelected(isSelected ? null : index);
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardGradientStart.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: AppColors.textGrey,
                            size: 32.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
