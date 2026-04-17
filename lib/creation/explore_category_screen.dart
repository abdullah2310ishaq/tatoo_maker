import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../l10n/app_localizations.dart';
import '../models/explore_category.dart';
import '../services/admob_ids.dart';
import '../utils/colors.dart';
import 'explore_detail_screen.dart';
import '../widgets/top_banner_ad.dart';
import '../widgets/remote_or_asset_image.dart';

class ExploreCategoryScreen extends StatefulWidget {
  final ExploreCategory category;

  const ExploreCategoryScreen({super.key, required this.category});

  @override
  State<ExploreCategoryScreen> createState() => _ExploreCategoryScreenState();
}

class _ExploreCategoryScreenState extends State<ExploreCategoryScreen> {
  static int _backToHomeCount = 0;
  bool _isHandlingBack = false;

  Future<void> _handleBackToHome() async {
    if (_isHandlingBack) return;
    _isHandlingBack = true;

    try {
      _backToHomeCount += 1;
      final shouldShowInterstitial = _backToHomeCount.isOdd;

      if (shouldShowInterstitial) {
        await _showInterstitialAdIfAvailable();
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      _isHandlingBack = false;
    }
  }

  Future<void> _showInterstitialAdIfAvailable() async {
    final unitId = AdmobIds.interstitialUnitId().trim();
    if (unitId.isEmpty) return;

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
          );
          try {
            ad.show();
          } catch (_) {
            ad.dispose();
            if (!completer.isCompleted) completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 4));
    } on TimeoutException {
      // Do not block back navigation if ad callbacks are delayed.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_handleBackToHome());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
          foregroundColor: textColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              unawaited(_handleBackToHome());
            },
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          title: Text(
            widget.category.title(l10n),
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
        body: Column(
          children: [
            const TopBannerAd(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    // Higher ratio => shorter cards (less height).
                    childAspectRatio: 1.02,
                  ),
                  itemCount: widget.category.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.category.items[index];
                    return _CategoryDetailCard(
                      title: item.title(l10n),
                      prompt: item.prompt(l10n),
                      bigImagePath: item.bigImagePath,
                      smallImagePath: item.smallImagePath,
                      smallImagePathDark: item.smallImagePathDark,
                      styleKey: item.id,
                    );
                  },
                ),
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
  final String? smallImagePathDark;
  final String? styleKey;

  const _CategoryDetailCard({
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    required this.smallImagePath,
    required this.smallImagePathDark,
    this.styleKey,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreDetailScreen(
              title: title,
              prompt: prompt,
              bigImagePath: bigImagePath,
              smallImagePath: smallImagePath,
              smallImagePathDark: smallImagePathDark,
              styleKey: styleKey,
            ),
          ),
        );
        if (result is String && result.trim().isNotEmpty && context.mounted) {
          // Bubble the selected prompt back to Home.
          Navigator.of(context).pop(result);
        }
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
          child: RemoteOrAssetImage(assetPath: bigImagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
