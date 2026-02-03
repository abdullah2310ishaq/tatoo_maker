import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../creation/explore_detail_screen.dart';
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
        'bigImage': 'assets/explore/floralbig.png',
        'smallImage': null,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeExploreInspiration,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: textColor,
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1,
          ),
          itemCount: inspirationItems.length,
          itemBuilder: (context, index) {
            final item = inspirationItems[index];
            return _InspirationCard(
              title: item['title']!,
              prompt: item['prompt']!,
              bigImagePath: item['bigImage']!,
              smallImagePath: item['smallImage'],
            );
          },
        ),
      ],
    );
  }
}

class _InspirationCard extends StatelessWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;

  const _InspirationCard({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    required this.smallImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreDetailScreen(
              title: title,
              prompt: prompt,
              bigImagePath: bigImagePath,
              smallImagePath: smallImagePath,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFFE8B3A), width: 1.5.w),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            bigImagePath,
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
