import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../flower_svg_loader.dart';

/// Widget for displaying a character box with floral SVG above it
class CharacterBoxWidget extends StatelessWidget {
  final String letter;
  final bool isDark;
  final double boxSize;
  final double svgHeight;

  const CharacterBoxWidget({
    super.key,
    required this.letter,
    required this.isDark,
    required this.boxSize,
    required this.svgHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
          // Character box
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
                  fontSize: boxSize * 0.5,
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
}
