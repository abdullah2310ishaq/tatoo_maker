import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../l10n/app_localizations.dart';
import '../utils/colors.dart';
import 'explore_detail_screen.dart';

class ExploreCategoryScreen extends StatelessWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;

  const ExploreCategoryScreen({
    super.key,
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    // For now, use 4 repeated cards based on the current item.
    final items = List.generate(4, (index) {
      return {
        'title': title,
        'prompt': prompt,
        'bigImage': bigImagePath,
        'smallImage': smallImagePath ?? bigImagePath,
      };
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeExploreInspiration,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: textColor.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.8,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _CategoryDetailCard(
                    title: item['title']!,
                    prompt: item['prompt']!,
                    bigImagePath: item['bigImage']!,
                    smallImagePath: item['smallImage'],
                  );
                },
              ),
            ),
          ],
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

  const _CategoryDetailCard({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    required this.smallImagePath,
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
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFFE8B3A),
            width: 1.5.w,
          ),
          color: isDark ? AppColors.cardGradientStart : AppColors.lightBackground,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Positioned.fill(
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

