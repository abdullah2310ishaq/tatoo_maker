import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _currentStep / 5;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Back button
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                  ),
                  onPressed: () {
                    if (_currentStep > 1) {
                      setState(() {
                        _currentStep--;
                      });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Step indicator
                Text(
                  'Step $_currentStep/5',
                  style: TextStyle(
                    fontSize: 16,
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
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE8B3A), // Orange accent
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Question
                Text(
                  _getQuestion(_currentStep),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                    fontFamily: 'Amaranth',
                  ),
                ),
                const SizedBox(height: 30),
                // Input field
                _buildInputField(_currentStep, isDark),
                const Spacer(),
                // Next button
                _buildNextButton(isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getQuestion(int step) {
    switch (step) {
      case 1:
        return "What's your name?";
      case 2:
        return "What's your favorite tattoo style?";
      case 3:
        return "Where would you like your tattoo?";
      case 4:
        return "What size are you thinking?";
      case 5:
        return "Any specific colors in mind?";
      default:
        return "";
    }
  }

  String _getPlaceholder(int step) {
    switch (step) {
      case 1:
        return "Name";
      case 2:
        return "Style preference";
      case 3:
        return "Body location";
      case 4:
        return "Size preference";
      case 5:
        return "Color preferences";
      default:
        return "";
    }
  }

  Widget _buildInputField(int step, bool isDark) {
    final controller = _controllers[step - 1];
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final borderColor = const Color(0xFFFE8B3A); // Orange accent

    return Container(
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
          hintText: _getPlaceholder(step),
          hintStyle: TextStyle(fontSize: 16, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildNextButton(bool isDark) {
    final controller = _controllers[_currentStep - 1];
    final hasText = controller.text.trim().isNotEmpty;
    final isLastStep = _currentStep == 5;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: hasText
            ? () {
                if (isLastStep) {
                  // Complete onboarding and navigate back
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _currentStep++;
                  });
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasText
              ? const Color(0xFFA6541D) // Burnt orange
              : (isDark
                    ? AppColors.buttonBackground
                    : AppColors.textGrey.withOpacity(0.1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: hasText ? 4 : 0,
        ),
        child: Text(
          isLastStep ? 'Get Started' : 'Next',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: hasText
                ? Colors.white
                : (isDark ? AppColors.textGrey : AppColors.textGrey),
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
