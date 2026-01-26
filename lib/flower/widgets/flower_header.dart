import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// Header widget for flower input screen with back button and title
class FlowerHeader extends StatelessWidget {
  final VoidCallback onBack;

  const FlowerHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
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
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
