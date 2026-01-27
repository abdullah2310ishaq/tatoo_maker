import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'widgets/flower_header.dart';
import 'widgets/name_display.dart';
import 'widgets/character_boxes_grid.dart';
import 'widgets/flower_keyboard.dart';
import 'widgets/generate_button.dart';

class FlowerInputScreen extends StatefulWidget {
  const FlowerInputScreen({super.key});

  @override
  State<FlowerInputScreen> createState() => _FlowerInputScreenState();
}

class _FlowerInputScreenState extends State<FlowerInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to text changes for auto-scroll only (no setState to avoid rebuilds)
    _nameController.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    // Auto-scroll to bottom when new character is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && mounted) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleTextChange);
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == 'ar';

    // Force English locale for this screen when Arabic is selected
    final locale = isArabic ? const Locale('en') : currentLocale;

    return Localizations.override(
      context: context,
      locale: locale,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: SafeArea(
            child: Column(
              children: [
                // Header
                FlowerHeader(
                  onBack: () => Navigator.of(context).pop(),
                  isRTL: isArabic,
                ),
                SizedBox(height: 20.h),
                // Name display - use ValueListenableBuilder to rebuild only this part
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _nameController,
                  builder: (context, value, child) {
                    return NameDisplay(name: value.text);
                  },
                ),
                // Conditional spacing and character boxes - rebuild only when text changes
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _nameController,
                  builder: (context, value, child) {
                    final name = value.text;
                    if (name.isEmpty) return const SizedBox.shrink();
                    return SizedBox(height: 20.h);
                  },
                ),
                // Scrollable area: Character boxes - rebuild only when text changes
                Expanded(
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _nameController,
                    builder: (context, value, child) {
                      final name = value.text;
                      if (name.isEmpty) return const SizedBox.shrink();
                      return SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            CharacterBoxesGrid(
                              key: ValueKey(name), // Use key to optimize rebuilds
                              name: name,
                              isDark: isDark,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                // Generate button - rebuild only when text changes
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _nameController,
                  builder: (context, value, child) {
                    final name = value.text;
                    if (name.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: [
                        GenerateButton(name: name),
                        SizedBox(height: 20.h),
                      ],
                    );
                  },
                ),
                // Custom keyboard - no rebuild needed when text changes
                FlowerKeyboard(
                  onKeyPressed: (letter) {
                    final newText = _nameController.text + letter;
                    _nameController.value = TextEditingValue(
                      text: newText,
                      selection: TextSelection.collapsed(offset: newText.length),
                    );
                  },
                  onBackspace: () {
                    if (_nameController.text.isNotEmpty) {
                      final newText = _nameController.text.substring(
                        0,
                        _nameController.text.length - 1,
                      );
                      _nameController.value = TextEditingValue(
                        text: newText,
                        selection: TextSelection.collapsed(offset: newText.length),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
