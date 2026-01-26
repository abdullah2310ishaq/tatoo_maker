import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class OnboardingNextButton extends StatelessWidget {
  final bool enabled;
  final bool isLastStep;
  final VoidCallback onPressed;

  const OnboardingNextButton({
    super.key,
    required this.enabled,
    required this.isLastStep,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? const Color(0xFFA6541D) // Burnt orange
              : (isDark
                    ? AppColors.buttonBackground
                    : AppColors.textGrey.withOpacity(0.1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: enabled ? 4 : 0,
        ),
        child: Text(
          isLastStep
              ? AppLocalizations.of(context)!.onboardingGetStarted
              : AppLocalizations.of(context)!.next,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: enabled
                ? Colors.white
                : (isDark ? AppColors.textGrey : AppColors.textGrey),
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
