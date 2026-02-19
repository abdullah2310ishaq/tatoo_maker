import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../creation/explore_category_screen.dart';
import '../../creation/explore_detail_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../models/explore_category.dart';
import '../../utils/colors.dart';

class ExploreInspirationSection extends StatelessWidget {
  const ExploreInspirationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    // Use the 10 categories from ExploreData
    final categories = ExploreData.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _CategoryRow(category: category, textColor: textColor),
            );
          }),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ExploreCategory category;
  final Color textColor;

  const _CategoryRow({required this.category, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreCategoryScreen(category: category),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: category label (left) + "See all" text (right), with outer padding
          Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.title(l10n),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  l10n.homeSeeAll,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Row 2: two equal cards showing first 2 items from category
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (category.items.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExploreDetailScreen(
                              title: category.items[0].title(l10n),
                              prompt: category.items[0].prompt(l10n),
                              bigImagePath: category.items[0].bigImagePath,
                              smallImagePath: category.items[0].smallImagePath,
                              smallImagePathDark:
                                  category.items[0].smallImagePathDark,
                              styleKey: category.items[0].id,
                            ),
                          ),
                        );
                      }
                    },
                    child: _CategoryImage(
                      imagePath: category.items.isNotEmpty
                          ? category.items[0].bigImagePath
                          : category.bigImagePath,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (category.items.length > 1) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ExploreDetailScreen(
                              title: category.items[1].title(l10n),
                              prompt: category.items[1].prompt(l10n),
                              bigImagePath: category.items[1].bigImagePath,
                              smallImagePath: category.items[1].smallImagePath,
                              smallImagePathDark:
                                  category.items[1].smallImagePathDark,
                              styleKey: category.items[1].id,
                            ),
                          ),
                        );
                      }
                    },
                    child: _CategoryImage(
                      imagePath: category.items.length > 1
                          ? category.items[1].bigImagePath
                          : category.bigImagePath,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  final String imagePath;

  const _CategoryImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Force both cards to have the same width:height ratio so their
    // visual size matches exactly on each row.
    return AspectRatio(
      aspectRatio: 1.0, // square cards, same size for both
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFFE8B3A), width: 1.5.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            imagePath,
            width: double.infinity,
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
