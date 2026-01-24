import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'flower_svg_loader.dart';

class FlowerInputScreen extends StatefulWidget {
  const FlowerInputScreen({super.key});

  @override
  State<FlowerInputScreen> createState() => _FlowerInputScreenState();
}

class _FlowerInputScreenState extends State<FlowerInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
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
    _focusNode.dispose();
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
              // Fixed header: Back button + "Enter Your Name" in same row
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.buttonBackground
                              : AppColors.textGrey.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.titleGradientStart,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // "Enter Your Name" text
                    Expanded(
                      child: Text(
                        'Enter Your Name',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textWhite
                              : AppColors.textPrimary,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Name text display (fixed)
              if (_nameController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    _nameController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                ),
              if (_nameController.text.isNotEmpty) const SizedBox(height: 20),
              // Scrollable area: Floral sprigs and character boxes
              Expanded(
                child: _nameController.text.isEmpty
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Character boxes with SVGs above them (4 per row)
                            _buildCharacterBoxes(_nameController.text, isDark),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
              // Custom keyboard
              _buildCustomKeyboard(),
              const SizedBox(height: 20),
              // Generate button (shown when name is entered)
              if (_nameController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to next step with name
                        Navigator.of(context).pop(_nameController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFA6541D,
                        ), // Burnt orange
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Generate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Amaranth',
                        ),
                      ),
                    ),
                  ),
                ),
              if (_nameController.text.isNotEmpty) const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomKeyboard() {
    // Keyboard layout
    final List<List<String>> keyboardLayout = [
      ['Q', 'W', 'R', 'T', 'Y', 'U', 'I', 'D', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACKSPACE'],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate key size based on available width
        // Account for container padding (16*2 = 32) and key padding (3*2 = 6 per key)
        final maxKeysInRow = 9;
        final containerPadding = 32.0; // 16 on each side
        final keyPadding = 6.0; // 3 on each side of key (Padding widget)
        final safetyMargin =
            8.0; // Margin to prevent overflow (accounts for borders and rounding)
        final availableWidth =
            constraints.maxWidth - containerPadding - safetyMargin;
        // Each key takes keyWidth + keyPadding, so for 9 keys: 9*(keyWidth + keyPadding) = availableWidth
        // 9*keyWidth + 9*keyPadding = availableWidth
        // keyWidth = (availableWidth - 9*keyPadding) / 9
        final keyWidth =
            (availableWidth - (maxKeysInRow * keyPadding)) / maxKeysInRow;
        final keyHeight = keyWidth * 1.33; // Maintain aspect ratio

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: keyboardLayout.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: row.map((key) {
                    if (key == 'BACKSPACE') {
                      return _buildBackspaceKey(keyWidth, keyHeight);
                    }
                    return _buildKey(key, keyWidth, keyHeight);
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildKey(String letter, double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _nameController.text += letter;
          });
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF121212), // Deep dark background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFF9800), // Orange/amber border
              width: 1.5,
            ),
            boxShadow: [
              // Inner glow effect at bottom
              BoxShadow(
                color: const Color(0xFFFF9800).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: const Color(0xFFFF9800), // Orange/amber text
                fontSize: width * 0.55, // Responsive font size
                fontWeight: FontWeight.w600,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloralSprigs(String name, bool isDark) {
    final characters = name.toUpperCase().split('');
    final rows = <List<String>>[];

    // Split into rows of 4
    for (int i = 0; i < characters.length; i += 4) {
      rows.add(
        characters.sublist(
          i,
          (i + 4 < characters.length) ? i + 4 : characters.length,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate size based on available width
        // 4 items per row, with 8px padding on each side (16px total per item)
        final horizontalPadding = 80.0; // 40 on each side
        final itemsPerRow = 4;
        final itemPadding = 16.0; // 8 on each side
        final availableWidth = constraints.maxWidth - horizontalPadding;
        final totalItemPadding = itemPadding * itemsPerRow;
        final itemWidth = (availableWidth - totalItemPadding) / itemsPerRow;
        final itemHeight = itemWidth * 0.83; // Maintain aspect ratio

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((char) {
                    return _buildFloralSprig(
                      char,
                      isDark,
                      itemWidth,
                      itemHeight,
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFloralSprig(
    String letter,
    bool isDark,
    double width,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FlowerSvgLoader.buildFloralSprigSvg(
        letter: letter,
        isDark: isDark,
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildCharacterBoxes(String name, bool isDark) {
    final characters = name.toUpperCase().split('');
    final rows = <List<String>>[];

    // Split into rows of 4
    for (int i = 0; i < characters.length; i += 4) {
      rows.add(
        characters.sublist(
          i,
          (i + 4 < characters.length) ? i + 4 : characters.length,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate size based on available width
        // 4 items per row, with small padding for gaps
        final horizontalPadding =
            30.0; // 10 left, 20 right (start from more left)
        final itemsPerRow = 4;
        final itemPadding = 4.0; // 2px on each side (small gap between letters)
        final availableWidth = constraints.maxWidth - horizontalPadding;
        final totalItemPadding = itemPadding * itemsPerRow;
        final itemWidth = (availableWidth - totalItemPadding) / itemsPerRow;
        // Make character boxes smaller to prevent overflow
        final boxSize = itemWidth.clamp(
          30.0,
          42.0, // Further reduced max size to prevent overflow
        );
        // SVG height will be calculated in loader based on boxSize
        final svgHeight =
            boxSize * 1.0; // Same size as box for better visibility

        return Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 20.0,
          ), // Start from more left
          child: Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: row.map((char) {
                    return _buildCharacterBox(char, isDark, boxSize, svgHeight);
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCharacterBox(
    String letter,
    bool isDark,
    double boxSize,
    double svgHeight,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
      ), // Small gap between letters
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Floral sprig PNG above the box
          FlowerSvgLoader.buildCharacterBoxSvg(
            letter: letter,
            isDark: isDark,
            boxSize: boxSize,
            svgHeight: svgHeight,
          ),
          const SizedBox(height: 8),
          // Character box (smaller)
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: const Color(0xFF121212), // Deep dark background
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFF9800), // Orange/amber border
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                  fontSize: boxSize * 0.5, // Slightly smaller font
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Amaranth',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackspaceKey(double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_nameController.text.isNotEmpty) {
              _nameController.text = _nameController.text.substring(
                0,
                _nameController.text.length - 1,
              );
            }
          });
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF121212), // Deep dark background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFF9800), // Orange/amber border
              width: 1.5,
            ),
            boxShadow: [
              // Inner glow effect at bottom
              BoxShadow(
                color: const Color(0xFFFF9800).withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.backspace,
              color: const Color(0xFFFF9800), // Orange/amber icon
              size: width * 0.55, // Responsive icon size
            ),
          ),
        ),
      ),
    );
  }
}
