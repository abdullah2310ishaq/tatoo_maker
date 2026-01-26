import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// Widget for displaying the entered name
class NameDisplay extends StatelessWidget {
  final String name;

  const NameDisplay({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textWhite : AppColors.textPrimary,
          fontFamily: 'Amaranth',
        ),
      ),
    );
  }
}
