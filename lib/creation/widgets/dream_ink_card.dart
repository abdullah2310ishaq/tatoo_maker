import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/colors.dart';

class DreamInkCard extends StatelessWidget {
  final GlobalKey cardKey;
  final TextEditingController controller;
  final int maxCharacters;
  final ValueChanged<String> onChanged;
  final Future<bool> Function(String assetPath) checkAssetExists;

  const DreamInkCard({
    super.key,
    required this.cardKey,
    required this.controller,
    required this.maxCharacters,
    required this.onChanged,
    required this.checkAssetExists,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;

    return SizedBox(
      key: cardKey,
      height: 280.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.titleGradientStart, width: 1.w),
          color: cardBgColor,
          gradient: cardGradient,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Stack(
              children: [
                // Orange glow: clipped to the same border radius, anchored to corner
                if (isDark)
                  Positioned(
                    top: -50.h,
                    right: -50.w,
                    child: IgnorePointer(
                      child: Container(
                        width: 180.w,
                        height: 180.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.topRight,
                            radius: 0.9,
                            colors: [
                              AppColors.cardGlowStart,
                              AppColors.cardGlowEnd,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeDescribeYourDreamInk,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Amaranth',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLength: maxCharacters,
                        maxLines: null,
                        style: TextStyle(fontSize: 14.sp, color: textColor),
                        decoration: InputDecoration(
                          hintText: l10n.homeDreamInkHint,
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Divider(
                      color: AppColors.textGrey.withOpacity(0.3),
                      thickness: 1.h,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FutureBuilder<bool>(
                              future: checkAssetExists('assets/inspiration.svg'),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return SvgPicture.asset(
                                    'assets/inspiration.svg',
                                    width: 22.w,
                                    height: 22.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.textGrey,
                                      BlendMode.srcIn,
                                    ),
                                  );
                                }
                                return Icon(
                                  Icons.casino_outlined,
                                  size: 22.sp,
                                  color: AppColors.textGrey,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              l10n.homeInspiration,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${maxCharacters - controller.text.length} ${l10n.homeCharactersRemaining}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

