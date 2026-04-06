import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';
import '../../widgets/inkvision_underline.dart';

class HomeHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onMenuTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onProTap;

  const HomeHeader({
    super.key,
    required this.isDark,
    required this.onMenuTap,
    this.onHistoryTap,
    this.onProTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final menuIconAsset = isDark
        ? 'assets/drawer_dark.svg'
        : 'assets/drawer_light.svg';
    final historyIconAsset = isDark
        ? 'assets/history_dark.svg'
        : 'assets/history_light.svg';
    // Keep header actions aligned across light/dark themes.
    final double actionSize = 40.w;
    final double menuIconSize = 46.w;
    final double historyIconSize = 52.w;
    final double proBadgeSize = actionSize;

    // LTR so menu stays left and history right (same as English) in Arabic
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Menu button (left)
          IconButton(
            padding: EdgeInsets.zero,

            icon: SvgPicture.asset(
              menuIconAsset,
              width: menuIconSize,
              height: menuIconSize,
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 28.sp),
            ),
            onPressed: onMenuTap,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Tattoo',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textWhite
                        : AppColors.darkBackground,
                    fontFamily: 'Tomorrow',
                  ),
                ),
                SizedBox(height: 6.h),
                InkVisionUnderline(width: 120.w, height: 3.h),
              ],
            ),
          ),
          // Pro + History actions (right)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  historyIconAsset,
                  width: historyIconSize,
                  height: historyIconSize,
                  placeholderBuilder: (context) =>
                      Icon(Icons.history, color: iconColor, size: 28.sp),
                ),
                onPressed: onHistoryTap,
              ),
              SizedBox(width: 6.w),
              Transform.translate(
                offset: Offset(0, -2.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(proBadgeSize / 2),
                    onTap: onProTap,
                    child: SizedBox(
                      width: proBadgeSize,
                      height: proBadgeSize,
                      child: Center(
                        child: Container(
                          width: proBadgeSize,
                          height: proBadgeSize,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.proBadgeBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            'Pro',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
