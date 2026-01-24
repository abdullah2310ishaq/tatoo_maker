import 'package:flutter/material.dart';
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
    final maxCharacters = 500;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingHeader(currentStep: 4, onBack: onBack),
            const SizedBox(height: 50),
            // Question
            Text(
              "What your tattoo idea?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            const SizedBox(height: 30),
            // Big input container like homepage
            Flexible(
              child: SizedBox(
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.titleGradientStart,
                      width: 1,
                    ),
                    color: cardBgColor,
                    gradient: cardGradient,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'What your tattoo idea?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontFamily: 'Amaranth',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            fit: FlexFit.loose,
                            child: TextField(
                              controller: controller,
                              maxLength: maxCharacters,
                              maxLines: null,
                              style: TextStyle(fontSize: 14, color: textColor),
                              decoration: InputDecoration(
                                hintText: 'Describe your tattoo idea...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
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
            ),
            // Spacer - pushes button to bottom (like other pages)
            const Spacer(),
            // Next button
            OnboardingNextButton(
              enabled: controller.text.trim().isNotEmpty,
              isLastStep: false,
              onPressed: onNext,
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}
