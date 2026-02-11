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
  final ScrollController? scrollController;

  const TattooStyleSection({
    super.key,
    required this.styles,
    required this.selectedIndex,
    required this.onStyleTap,
    this.scrollController,
  });

  static bool _isRtlLocale(Locale locale) {
    const rtlCodes = ['ar', 'he', 'fa', 'ur'];
    return rtlCodes.contains(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final locale = Localizations.localeOf(context);
    final isRtl = _isRtlLocale(locale);

    // Parent provides start padding (LTR=left, RTL=right). Scroll side has no padding.
    final sectionPadding = EdgeInsets.zero;
    final content = Padding(
      padding: sectionPadding,
      child: Column(
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
              controller: scrollController,
              key: ValueKey(ThemeProvider.of(context)?.isDarkTheme ?? false),
              scrollDirection: Axis.horizontal,
              itemCount: styles.length,
              separatorBuilder: (_, __) => SizedBox(width: 2.w),
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
        ],
      ),
    );
    if (!isRtl) return content;
    return Directionality(textDirection: TextDirection.rtl, child: content);
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

      case 'Abstract':
        return l10n.styleAbstract;
      case 'Butterfly':
        return l10n.styleButterfly;
      case 'Unicorn':
        return l10n.styleUnicorn;
      case 'Eagle':
        return l10n.styleEagle;
      case 'Lion':
        return l10n.styleLion;
      case 'Floral':
        return l10n.styleFloral;
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

    // Narrower cards so more styles fit on screen
    final double width = isSelected ? 100.w : 82.w;
    final Color borderColor = isSelected
        ? AppColors.navBarActive
        : AppColors.cardGradientEnd;
    final cardBgColor = isDark
        ? const Color(0xFF151411)
        : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final localizedLabel = _localizedLabel(item.label, l10n);

    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.96,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: 1.4.w),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.navBarActive.withValues(alpha: 0.35),
                    blurRadius: 12.r,
                    spreadRadius: 1,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(item.assetPath, fit: BoxFit.contain),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  localizedLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
