import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';
import '../../widgets/inkvision_underline.dart';

class HomeHeader extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onMenuTap;
  final VoidCallback? onHistoryTap;

  const HomeHeader({
    super.key,
    required this.isDark,
    required this.onMenuTap,
    this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final buttonBgColor = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/one.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 24.sp),
            ),
            onPressed: onMenuTap,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'InkVision',
                style: TextStyle(
                  fontSize: 32.sp,
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
        // History button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(Icons.history, color: iconColor, size: 24.sp),
            onPressed: onHistoryTap,
          ),
        ),
      ],
    );
  }
}
