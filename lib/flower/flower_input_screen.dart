import 'package:flutter/material.dart';
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
    // Listen to text changes to update UI and auto-scroll
    _nameController.addListener(() {
      setState(() {});
      // Auto-scroll to bottom when new character is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
              FlowerHeader(onBack: () => Navigator.of(context).pop()),
              const SizedBox(height: 20),
              // Name display
              NameDisplay(name: _nameController.text),
              if (_nameController.text.isNotEmpty) const SizedBox(height: 20),
              // Scrollable area: Character boxes
              Expanded(
                child: _nameController.text.isEmpty
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            CharacterBoxesGrid(
                              name: _nameController.text,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
              // Custom keyboard
              FlowerKeyboard(
                onKeyPressed: (letter) {
                  setState(() {
                    _nameController.text += letter;
                  });
                },
                onBackspace: () {
                  setState(() {
                    if (_nameController.text.isNotEmpty) {
                      _nameController.text = _nameController.text.substring(
                        0,
                        _nameController.text.length - 1,
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              // Generate button
              if (_nameController.text.isNotEmpty)
                GenerateButton(name: _nameController.text),
              if (_nameController.text.isNotEmpty) const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
