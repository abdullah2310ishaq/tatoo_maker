import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/explore_category.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../services/native_small_ad_view.dart';
import '../services/remote_config_service.dart';
import '../utils/colors.dart';
import '../widgets/interstitial_ad_loading_dialog.dart';
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
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;
    if (isPro) return;

    final unitId = AdIds.testInterId.trim();
    if (unitId.isEmpty) return;

    final loadingHandle = await showInterstitialAdLoadingDialog(
      context,
      minShowDuration: const Duration(seconds: 2),
      safetyTimeout: const Duration(seconds: 4),
    );

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
          );
          try {
            await loadingHandle.waitForMinShowDuration();
            await Future<void>.delayed(const Duration(milliseconds: 150));
            ad.show();
          } catch (_) {
            ad.dispose();
            loadingHandle.close();
            if (!completer.isCompleted) completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          loadingHandle.close();
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 4));
    } on TimeoutException {
      // Do not block back navigation if ad callbacks are delayed.
      loadingHandle.close();
    }
  }

  static const int _crossAxisCount = 2;
  /// 3 rows × 2 columns — native ad sits after this many items.
  static const int _itemsBeforeNativeAd = 6;

  SliverGridDelegate get _gridDelegate => SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        // Higher ratio => shorter cards (less height).
        childAspectRatio: 1.02,
      );

  Widget _buildCategoryCard(
    BuildContext context,
    AppLocalizations l10n,
    int index,
  ) {
    final item = widget.category.items[index];
    return _CategoryDetailCard(
      title: item.title(l10n),
      prompt: item.prompt(l10n),
      bigImagePath: item.bigImagePath,
      smallImagePath: item.smallImagePath,
      smallImagePathDark: item.smallImagePathDark,
      styleKey: item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final l10n = AppLocalizations.of(context)!;
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    final rc = context.watch<RemoteConfigService>();
    final showBanner = !isPro && rc.seeAllShowBannerAd;
    final showNative = !isPro && rc.seeAllShowNativeAd;
    final items = widget.category.items;
    final firstBatchCount =
        showNative ? items.length.clamp(0, _itemsBeforeNativeAd) : items.length;
    final remainingCount =
        showNative ? (items.length - _itemsBeforeNativeAd).clamp(0, items.length) : 0;

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
            if (showBanner) const TopBannerAd(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    sliver: SliverGrid(
                      gridDelegate: _gridDelegate,
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildCategoryCard(context, l10n, index),
                        childCount: firstBatchCount,
                      ),
                    ),
                  ),
                  if (showNative)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      sliver: const SliverToBoxAdapter(
                        child: NativeSmallAdView(),
                      ),
                    ),
                  if (remainingCount > 0)
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      sliver: SliverGrid(
                        gridDelegate: _gridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildCategoryCard(
                            context,
                            l10n,
                            index + _itemsBeforeNativeAd,
                          ),
                          childCount: remainingCount,
                        ),
                      ),
                    )
                  else
                    SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                ],
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
