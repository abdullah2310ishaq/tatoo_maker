import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepNamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepNamePage({
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
            OnboardingHeader(currentStep: 1, onBack: onBack),
            const SizedBox(height: 40),
            // Question
            Text(
              "What's your name?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            const SizedBox(height: 30),
            // Input field
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.buttonBackground
                    : AppColors.lightCardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(fontSize: 16, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
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
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}
