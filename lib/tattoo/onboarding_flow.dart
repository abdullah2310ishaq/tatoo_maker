import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../creation/loading_screen.dart';
import '../providers/usage_limit_provider.dart';
import '../pro_access_screen.dart';
import '../home_shell.dart';
import 'onboarding/utils/zodiac_utils.dart';
import 'onboarding/pages/step_name_page.dart';
import 'onboarding/pages/step_birthday_page.dart';
import 'onboarding/pages/zodiac_display_page.dart';
import 'onboarding/pages/step_tattoo_idea_page.dart';
import 'onboarding/pages/step_style_selection_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  final PageController _pageController = PageController();
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  // Date picker state for step 2
  int _selectedMonth = 1;
  int _selectedDay = 4;
  int _selectedYear = DateTime.now().year - 18;

  // Tattoo style selection for step 4
  int? _selectedStyleIndex;

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;

          // Always close keyboard first.
          FocusManager.instance.primaryFocus?.unfocus();

          if (_currentStep > 1) {
            _goToStep(_currentStep - 1);
            return;
          }

          Navigator.of(context).pop();
        },
        child: Scaffold(
          // Keep onboarding steps stable when keyboard opens.
          // Pages that need keyboard visibility (e.g. StepTattooIdeaPage) handle
          // their own insets via padding/scroll.
          resizeToAvoidBottomInset: false,
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          body: Container(
            decoration: isDark
                ? ThemeManager.darkModeBackgroundGradient
                : ThemeManager.lightModeBackground,
            child: Padding(
              // Steps with bottom ads (Birthday/Idea) need true edge-to-edge ads;
              // those pages handle their own content padding internally.
              padding: (_currentStep == 2 || _currentStep == 3)
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  void _goToStep(int step) {
    final next = step.clamp(1, 4);
    if (!mounted) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (_currentStep == next) return;
    setState(() => _currentStep = next);
    _pageController.jumpToPage(next - 1);
  }

  Future<void> _openZodiac() async {
    final zodiacSign = getZodiacSign(_selectedMonth, _selectedDay);
    final zodiacInfo = getZodiacData(context, zodiacSign);

    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ZodiacDisplayPage(
          zodiacInfo: zodiacInfo,
          onBack: () => Navigator.of(context).pop(false),
          onNext: () => Navigator.of(context).pop(true),
        ),
      ),
    );

    if (!mounted) return;
    if (result == true) _goToStep(3);
  }

  Widget _buildContent() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StepNamePage(
          controller: _controllers[0],
          onBack: () => Navigator.of(context).pop(),
          onNext: () => _goToStep(2),
        ),
        StepBirthdayPage(
          selectedMonth: _selectedMonth,
          selectedDay: _selectedDay,
          selectedYear: _selectedYear,
          onMonthChanged: (index) => setState(() => _selectedMonth = index),
          onDayChanged: (day) => setState(() => _selectedDay = day),
          onYearChanged: (year) => setState(() => _selectedYear = year),
          onBack: () => _goToStep(1),
          onNext: _openZodiac,
        ),
        StepTattooIdeaPage(
          controller: _controllers[2],
          onBack: () => _goToStep(2),
          onNext: () => _goToStep(4),
        ),
        StepStyleSelectionPage(
          selectedStyleIndex: _selectedStyleIndex,
          onStyleSelected: (index) => setState(() => _selectedStyleIndex = index),
          onBack: () => _goToStep(3),
          onNext: () => _startGenerationFlow(context),
        ),
      ],
    );
  }

  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Future<void> _startGenerationFlow(BuildContext context) async {
    final usageLimitProvider = context.read<UsageLimitProvider>();
    final canStartGeneration = await usageLimitProvider.canStartGeneration();
    if (!context.mounted) return;
    if (!canStartGeneration) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProAccessScreen(
            showInterstitialOnClose: false,
            goToNextScreenOnClose: true,
            nextScreen: const HomeShell(),
          ),
        ),
      );
      return;
    }

    final name = _controllers[0].text.trim();
    final tattooIdea = _controllers[2].text.trim();
    final zodiacSign = getZodiacSign(_selectedMonth, _selectedDay);
    final dobFormatted =
        '${_monthNames[_selectedMonth - 1]} $_selectedDay, $_selectedYear';

    final selectedStyle = _selectedStyleIndex != null
        ? getTattooStyles(
            context,
            Theme.of(context).brightness == Brightness.dark,
          )[_selectedStyleIndex!]
        : null;

    if (selectedStyle != null && tattooIdea.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            selectedStyleAsset: selectedStyle.assetPath,
            styleName: selectedStyle.label,
            promptText: tattooIdea,
            name: name,
            dobFormatted: dobFormatted,
            zodiacSign: zodiacSign,
          ),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
