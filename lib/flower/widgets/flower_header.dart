import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/colors.dart';

/// Header widget for flower input screen with back button and title
class FlowerHeader extends StatelessWidget {
  final VoidCallback onBack;
  final bool isRTL;

  const FlowerHeader({super.key, required this.onBack, this.isRTL = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button (positioned based on RTL) - same as OnboardingHeader
          Align(
            alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.buttonBackground
                    : AppColors.textGrey.withOpacity(0.1),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.titleGradientStart,
                  size: 24,
                ),
                onPressed: onBack,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          // "Enter Your Name" text (centered) - localized
          Text(
            l10n.flowerInputEnterYourName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
