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
    final double menuSize = isDark ? 50.w : 60.w;
    final double historySize = isDark ? 50.w : 60.w;
    final double proBadgeHeight = isDark ? 32.w : 36.w;
    final double proBadgeWidth = isDark ? 40.w : 45.w;

    // LTR so menu stays left and history right (same as English) in Arabic
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button (left)
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              menuIconAsset,
              width: menuSize,
              height: menuSize,
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 32.sp),
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
              InkWell(
                borderRadius: BorderRadius.circular(24.r),
                onTap: onProTap,
                child: Container(
                  width: proBadgeWidth,
                  height: proBadgeHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.proBadgeBackground,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Pro',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  historyIconAsset,
                  width: historySize,
                  height: historySize,
                  placeholderBuilder: (context) =>
                      Icon(Icons.history, color: iconColor, size: 32.sp),
                ),
                onPressed: onHistoryTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
