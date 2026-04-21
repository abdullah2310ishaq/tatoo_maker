import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class OnboardingHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final bool showProgress;
  final Widget? trailing;

  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.onBack,
    this.showProgress = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Back button on left, optional action on right.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
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
                  size: 20,
                ),
                onPressed: onBack,
                padding: EdgeInsets.zero,
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
        if (showProgress) ...[
          const SizedBox(height: 20),
          // Step indicator
          Text(
            AppLocalizations.of(context)!.onboardingStep(currentStep),
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.textGrey.withOpacity(0.2)
                  : AppColors.textGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: currentStep / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFE8B3A), // Orange accent
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
