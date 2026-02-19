import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../models/explore_category.dart';
import '../utils/colors.dart';
import 'explore_detail_screen.dart';

class ExploreCategoryScreen extends StatelessWidget {
  final ExploreCategory category;

  const ExploreCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          category.title(l10n),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.8,
          ),
          itemCount: category.items.length,
          itemBuilder: (context, index) {
            final item = category.items[index];
            return _CategoryDetailCard(
              title: item.title(l10n),
              prompt: item.prompt(l10n),
              bigImagePath: item.bigImagePath,
              smallImagePath: item.smallImagePath,
              smallImagePathDark: item.smallImagePathDark,
            );
          },
        ),
      ),
    );
  }
}

class _CategoryDetailCard extends StatelessWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final String? smallImagePathDark;

  const _CategoryDetailCard({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    required this.smallImagePath,
    required this.smallImagePathDark,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreDetailScreen(
              title: title,
              prompt: prompt,
              bigImagePath: bigImagePath,
              smallImagePath: smallImagePath,
              smallImagePathDark: smallImagePathDark,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFE8B3A), width: 1.5.w),
          color: isDark
              ? AppColors.cardGradientStart
              : AppColors.lightBackground,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            bigImagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.cardGradientStart,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textGrey,
                    size: 24.sp,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
