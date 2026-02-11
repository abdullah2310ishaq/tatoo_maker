import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../creation/explore_category_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/colors.dart';

class ExploreInspirationSection extends StatelessWidget {
  const ExploreInspirationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    final List<Map<String, String?>> inspirationItems = [
      {
        'title': l10n.exploreTitleGothqueen,
        'prompt': l10n.explorePromptGothqueen,
        'bigImage': 'assets/explore/gothbig.png',
        'smallImage': 'assets/explore/gothsmall.png',
      },
      {
        'title': l10n.exploreTitleFloral,
        'prompt': l10n.explorePromptFloral,
        // Floral: only `floralsmall.png` exists; use it for both slots.
        'bigImage': 'assets/explore/floralbig.png',
        'smallImage': 'assets/explore/floralsmall.png',
      },
      {
        'title': l10n.exploreTitleSkullWithFedoraAndPipe,
        'prompt': l10n.explorePromptSkullWithFedoraAndPipe,
        'bigImage': 'assets/explore/skullbig.png',
        'smallImage': 'assets/explore/skullsmall.png',
      },
      {
        'title': l10n.exploreTitleElegantSnakeTattoo,
        'prompt': l10n.explorePromptElegantSnakeTattoo,
        'bigImage': 'assets/explore/snakebig.png',
        'smallImage': 'assets/explore/snakesmall.png',
      },
      {
        'title': l10n.exploreTitleFeatherAndBirdsInFlight,
        'prompt': l10n.explorePromptFeatherAndBirdsInFlight,
        'bigImage': 'assets/explore/featherbig.png',
        'smallImage': 'assets/explore/feathersmall.png',
      },
      {
        'title': l10n.exploreTitleRainyBatWithCelestialStars,
        'prompt': l10n.explorePromptRainyBatWithCelestialStars,
        'bigImage': 'assets/explore/batbig.png',
        'smallImage': 'assets/explore/batsmall.png',
      },
      {
        'title': l10n.exploreTitleElegantBlackCatSilhouetteDesign,
        'prompt': l10n.explorePromptElegantBlackCatSilhouetteDesign,
        'bigImage': 'assets/explore/catbig.png',
        'smallImage': 'assets/explore/catsmall.png',
      },
      {
        'title': l10n.exploreTitleRedRoseTattooDesign,
        'prompt': l10n.explorePromptRedRoseTattooDesign,
        'bigImage': 'assets/explore/rosebig.png',
        'smallImage': 'assets/explore/rosesmall.png',
      },
      {
        'title': l10n.exploreTitleBlackInfinityArrowTattoo,
        'prompt': l10n.explorePromptBlackInfinityArrowTattoo,
        'bigImage': 'assets/explore/infinitybig.png',
        'smallImage': 'assets/explore/infinitysmall.png',
      },
      {
        'title': l10n.exploreTitleBlackScorpionTattooDesign,
        'prompt': l10n.explorePromptBlackScorpionTattooDesign,
        'bigImage': 'assets/explore/scorpionbig.png',
        'smallImage': 'assets/explore/scorpionsmall.png',
      },
      {
        'title': l10n.exploreTitleCrescentMoonAndStarTattoo,
        'prompt': l10n.explorePromptCrescentMoonAndStarTattoo,
        'bigImage': 'assets/explore/moonbig.png',
        'smallImage': 'assets/explore/moonsmall.png',
      },
      {
        'title': l10n.exploreTitleSleepingPandaTattoo,
        'prompt': l10n.explorePromptSleepingPandaTattoo,
        'bigImage': 'assets/explore/pandabig.png',
        'smallImage': 'assets/explore/pandasmall.png',
      },
    ];

    // Use the first 10 items as "categories", each showing 2 images.
    final categories = inspirationItems.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(categories.length, (index) {
            final item = categories[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _CategoryRow(
                title: item['title']!,
                prompt: item['prompt']!,
                bigImagePath: item['bigImage']!,
                smallImagePath: item['smallImage'],
                textColor: textColor,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final Color textColor;

  const _CategoryRow({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    required this.smallImagePath,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreCategoryScreen(
              title: title,
              prompt: prompt,
              bigImagePath: bigImagePath,
              smallImagePath: smallImagePath,
            ),
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
                    title,
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
          // Row 2: two equal cards, slightly narrower with side padding
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Expanded(child: _CategoryImage(imagePath: bigImagePath)),
                SizedBox(width: 8.w),
                Expanded(
                  child: _CategoryImage(
                    imagePath: smallImagePath ?? bigImagePath,
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
