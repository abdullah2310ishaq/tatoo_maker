import 'package:flutter/material.dart';

/// Custom keyboard widget for flower input screen
class FlowerKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;

  const FlowerKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
  });

  static const List<List<String>> keyboardLayout = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACKSPACE'],
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate key size based on available width
        const maxKeysInRow = 10; // First row has 10 keys
        const containerPadding = 32.0; // 16 on each side
        const keyPadding = 6.0; // 3 on each side of key
        const safetyMargin = 8.0;
        final availableWidth =
            constraints.maxWidth - containerPadding - safetyMargin;
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
                      return _BackspaceKey(
                        width: keyWidth,
                        height: keyHeight,
                        onTap: onBackspace,
                      );
                    }
                    return _KeyboardKey(
                      letter: key,
                      width: keyWidth,
                      height: keyHeight,
                      onTap: () => onKeyPressed(key),
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
}

/// Individual keyboard key widget
class _KeyboardKey extends StatelessWidget {
  final String letter;
  final double width;
  final double height;
  final VoidCallback onTap;

  const _KeyboardKey({
    required this.letter,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
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
                color: const Color(0xFFFF9800).withValues(alpha: 0.3),
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
                fontSize: width * 0.55,
                fontWeight: FontWeight.w600,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backspace key widget
class _BackspaceKey extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const _BackspaceKey({
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
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
                color: const Color(0xFFFF9800).withValues(alpha: 0.3),
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
              size: width * 0.55,
            ),
          ),
        ),
      ),
    );
  }
}
