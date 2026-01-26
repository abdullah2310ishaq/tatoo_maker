import 'package:flutter/material.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isDark;

  const EmptyStateWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 80, color: AppColors.textGrey),
          const SizedBox(height: 24),
          Text(
            l10n.virtualTryOnEmptyState,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
        ],
      ),
    );
  }
}
