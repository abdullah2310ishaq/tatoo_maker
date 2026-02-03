import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../creation/models/tattoo_style_item.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../../utils/colors.dart';

class TattooStyleSection extends StatelessWidget {
  final List<TattooStyleItem> styles;
  final int? selectedIndex;
  final ValueChanged<int> onStyleTap;
  final VoidCallback onGenerateTap;
  final bool generateEnabled;

  const TattooStyleSection({
    super.key,
    required this.styles,
    required this.selectedIndex,
    required this.onStyleTap,
    required this.onGenerateTap,
    required this.generateEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeTattooStyle,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 190.h,
          child: ListView.separated(
            key: ValueKey(ThemeProvider.of(context)?.isDarkTheme ?? false),
            scrollDirection: Axis.horizontal,
            itemCount: styles.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final item = styles[index];
              final bool isSelected = selectedIndex == index;
              return _StyleCard(
                item: item,
                isSelected: isSelected,
                onTap: () => onStyleTap(index),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
        _GenerateButton(enabled: generateEnabled, onTap: onGenerateTap),
      ],
    );
  }
}

class _StyleCard extends StatelessWidget {
  final TattooStyleItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  String _localizedLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Dragon':
        return l10n.styleDragon;
      case 'Unicorn':
        return l10n.styleUnicorn;
      case 'Floral':
        return l10n.styleFloral;
      case 'Abstract':
        return l10n.styleAbstract;
      case 'Butterfly':
        return l10n.styleButterfly;
      case 'Eagle':
        return l10n.styleEagle;
      case 'Lion':
        return l10n.styleLion;
      case 'Spider':
        return l10n.styleSpider;
      case 'Wolf':
        return l10n.styleWolf;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final double width = isSelected ? 150.w : 130.w;
    final Color borderColor =
        isSelected ? AppColors.navBarActive : AppColors.cardGradientEnd;
    final cardBgColor =
        isDark ? const Color(0xFF151411) : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final localizedLabel = _localizedLabel(item.label, l10n);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.4.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(item.assetPath, fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: Text(
                  localizedLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _GenerateButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFFA6541D) // Burnt orange when enabled
              : const Color(0xFF2A2A2A), // Dark grey when disabled
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xFFA6541D).withOpacity(0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            l10n.homeGenerate,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w600,
              color: enabled ? Colors.white : AppColors.textGrey,
              fontFamily: 'Amaranth',
              shadows: enabled
                  ? [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2.h),
                        blurRadius: 4.r,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

