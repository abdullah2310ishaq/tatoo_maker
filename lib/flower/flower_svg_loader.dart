import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Utility class for loading flower SVG assets based on theme
class FlowerSvgLoader {
  /// Manual mapping of letters to light theme paths (for dark theme) - supports both SVG and PNG
  static const Map<String, String> _lightPaths = {
    'a': 'assets/flower/light/a.png',
    'b': 'assets/flower/light/b.png',
    'c': 'assets/flower/light/c.png',
    'd': 'assets/flower/light/d.png',
    'e': 'assets/flower/light/e.png',
    'f': 'assets/flower/light/f.png',
    'g': 'assets/flower/light/g.png',
    'h': 'assets/flower/light/h.png',
    'i': 'assets/flower/light/i.png',
    'j': 'assets/flower/light/j.png',
    'k': 'assets/flower/light/k.png',
    'l': 'assets/flower/light/l.png',
    'm': 'assets/flower/light/m.png',
    'n': 'assets/flower/light/n.png',
    'o': 'assets/flower/light/o.png',
    'p': 'assets/flower/light/p.png',
    'q': 'assets/flower/light/q.png',
    'r': 'assets/flower/light/r.png',
    's': 'assets/flower/light/s.png',
    't': 'assets/flower/light/t.png',
    'u': 'assets/flower/light/u.png',
    'v': 'assets/flower/light/v.png',
    'w': 'assets/flower/light/w.png',
    'x': 'assets/flower/light/x.png',
    'y': 'assets/flower/light/y.png',
    'z': 'assets/flower/light/z.png',
  };

  /// Manual mapping of letters to dark theme paths (for light theme) - supports both SVG and PNG
  static const Map<String, String> _darkPaths = {
    'a': 'assets/flower/dark/a.png',
    'b': 'assets/flower/dark/b.png',
    'c': 'assets/flower/dark/c.png',
    'd': 'assets/flower/dark/d.png',
    'e': 'assets/flower/dark/e.png',
    'f': 'assets/flower/dark/f.png',
    'g': 'assets/flower/dark/g.png',
    'h': 'assets/flower/dark/h.png',
    'i': 'assets/flower/dark/i.png',
    'j': 'assets/flower/dark/j.png',
    'k': 'assets/flower/dark/k.png',
    'l': 'assets/flower/dark/l.png',
    'm': 'assets/flower/dark/m.png',
    'n': 'assets/flower/dark/n.png',
    'o': 'assets/flower/dark/o.png',
    'p': 'assets/flower/dark/p.png',
    'q': 'assets/flower/dark/q.png',
    'r': 'assets/flower/dark/r.png',
    's': 'assets/flower/dark/s.png',
    't': 'assets/flower/dark/t.png',
    'u': 'assets/flower/dark/u.png',
    'v': 'assets/flower/dark/v.png',
    'w': 'assets/flower/dark/w.png',
    'x': 'assets/flower/dark/x.png',
    'y': 'assets/flower/dark/y.png',
    'z': 'assets/flower/dark/z.png',
  };

  /// Gets the image path based on theme and letter
  ///
  /// - For dark theme: uses `assets/flower/light/` (white images)
  /// - For light theme: uses `assets/flower/dark/` (dark images)
  static String getImagePath(String letter, bool isDark) {
    final lowerLetter = letter.toLowerCase();
    final pathMap = isDark ? _lightPaths : _darkPaths;
    final path =
        pathMap[lowerLetter] ?? 'assets/flower/light/a.png'; // Default fallback
    return path;
  }

  /// Builds an SVG widget for a floral sprig
  ///
  /// [letter] - The letter to get the SVG for
  /// [isDark] - Whether the app is in dark theme
  /// [width] - Width of the SVG
  /// [height] - Height of the SVG
  static Widget buildFloralSprigSvg({
    required String letter,
    required bool isDark,
    required double width,
    required double height,
  }) {
    final imagePath = getImagePath(letter, isDark);

    // Ensure minimum sizes for visibility
    final finalWidth = width > 0 ? width : 50.0;
    final finalHeight = height > 0 ? height : 40.0;

    return SizedBox(
      width: finalWidth,
      height: finalHeight,
      child: Image.asset(
        imagePath,
        width: finalWidth,
        height: finalHeight,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Image Error (Floral) for path: $imagePath');
          // Try SVG as fallback
          final svgPath = imagePath.replaceAll('.png', '.svg');
          return SvgPicture.asset(
            svgPath,
            width: finalWidth,
            height: finalHeight,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('❌ SVG Fallback also failed: $svgPath');
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  /// Builds an SVG widget for character box (above the box)
  ///
  /// [letter] - The letter to get the SVG for
  /// [isDark] - Whether the app is in dark theme
  /// [boxSize] - Size of the character box
  /// [svgHeight] - Height of the SVG (usually boxSize * 0.67)
  static Widget buildCharacterBoxSvg({
    required String letter,
    required bool isDark,
    required double boxSize,
    required double svgHeight,
  }) {
    final imagePath = getImagePath(letter, isDark);

    // Make florals bigger than character boxes (2x width, 2.5x height)
    final finalWidth = (boxSize * 1.86).clamp(60.0, 84.0);
    final finalHeight = (boxSize * 2.2).clamp(35.0, 90.0);

    return SizedBox(
      width: finalWidth,
      height: finalHeight,
      child: Image.asset(
        imagePath,
        width: finalWidth,
        height: finalHeight,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Image Error for path: $imagePath - $error');
          // Try SVG as fallback
          final svgPath = imagePath.replaceAll('.png', '.svg');
          return SvgPicture.asset(
            svgPath,
            width: finalWidth,
            height: finalHeight,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('❌ SVG Fallback also failed: $svgPath');
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
