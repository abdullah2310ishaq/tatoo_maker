import 'package:flutter/material.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../../../utils/colors.dart';

class VirtualTryOnHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback onClose;

  const VirtualTryOnHeader({
    super.key,
    required this.isDark,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Positioned(
      top: 16,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 28,
            ),
            onPressed: onClose,
          ),
          Text(
            l10n.virtualTryOn,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
          const SizedBox(width: 48), // Balance the close button
        ],
      ),
    );
  }
}
