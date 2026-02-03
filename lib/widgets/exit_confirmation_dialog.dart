import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';

class ExitConfirmationDialog extends StatelessWidget {
  const ExitConfirmationDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ExitConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final backgroundColor = isDark
        ? AppColors.buttonBackground
        : AppColors.lightBackground;

    // final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity, // 85% of screen width
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.titleGradientStart.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              Icons.exit_to_app,
              size: 48,
              color: AppColors.titleGradientStart,
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              l10n.exitAppTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Amaranth',
              ),
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              l10n.exitAppMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: textColor.withValues(alpha: 0.7),
                fontFamily: 'Amaranth',
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: AppColors.titleGradientStart.withValues(
                          alpha: 0.5,
                        ),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Exit button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6541D), // Burnt orange
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.exit,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
