import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../creation/loading_screen.dart';
import '../creation/result_screen.dart';
import '../providers/usage_limit_provider.dart';
import '../pro_access_screen.dart';
import 'onboarding/utils/zodiac_utils.dart';
import 'onboarding/pages/step_name_page.dart';
import 'onboarding/pages/step_birthday_page.dart';
import 'onboarding/pages/zodiac_display_page.dart';
import 'onboarding/pages/step_location_page.dart';
import 'onboarding/pages/step_tattoo_idea_page.dart';
import 'onboarding/pages/step_style_selection_page.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 1;
  bool _showZodiac = false;
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  // Date picker state for step 2
  int _selectedMonth = 1;
  int _selectedDay = 4;
  int _selectedYear = DateTime.now().year - 18;

  // Tattoo style selection for step 5
  int? _selectedStyleIndex;

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

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildCurrentPage(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    if (_showZodiac) {
      final zodiacSign = getZodiacSign(_selectedMonth, _selectedDay);
      final zodiacInfo = getZodiacData(context, zodiacSign);
      return ZodiacDisplayPage(
        zodiacInfo: zodiacInfo,
        onBack: () {
          setState(() {
            _showZodiac = false;
          });
        },
        onNext: () {
          setState(() {
            _showZodiac = false;
            _currentStep = 3;
          });
        },
      );
    }

    switch (_currentStep) {
      case 1:
        return StepNamePage(
          controller: _controllers[0],
          onBack: () => Navigator.of(context).pop(),
          onNext: () => setState(() => _currentStep++),
        );
      case 2:
        return StepBirthdayPage(
          selectedMonth: _selectedMonth,
          selectedDay: _selectedDay,
          selectedYear: _selectedYear,
          onMonthChanged: (index) => setState(() => _selectedMonth = index),
          onDayChanged: (day) => setState(() => _selectedDay = day),
          onYearChanged: (year) => setState(() => _selectedYear = year),
          onBack: () => setState(() => _currentStep--),
          onNext: () {
            setState(() {
              _showZodiac = true;
            });
          },
        );
      case 3:
        return StepLocationPage(
          controller: _controllers[2],
          onBack: () => setState(() => _currentStep--),
          onNext: () => setState(() => _currentStep++),
        );
      case 4:
        return StepTattooIdeaPage(
          controller: _controllers[3],
          onBack: () => setState(() => _currentStep--),
          onNext: () => setState(() => _currentStep++),
        );
      case 5:
        return StepStyleSelectionPage(
          selectedStyleIndex: _selectedStyleIndex,
          onStyleSelected: (index) =>
              setState(() => _selectedStyleIndex = index),
          onBack: () => setState(() => _currentStep--),
          onNext: () => _startGenerationFlow(context),
        );
      default:
        return const SizedBox();
    }
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
            showInterstitialOnClose: true,
            goToNextScreenOnClose: true,
            nextScreen: const ResultScreen(
              styleName: '',
              generatedImageBytes: null,
              variationImages: null,
              promptText: null,
              showProAccessOnOpen: false,
            ),
          ),
        ),
      );
      return;
    }

    final name = _controllers[0].text.trim();
    final tattooIdea = _controllers[3].text.trim();
    final placeOfBirth = _controllers[2].text.trim();
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
            placeOfBirth: placeOfBirth.isEmpty ? null : placeOfBirth,
          ),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
