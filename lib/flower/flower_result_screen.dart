import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../providers/usage_limit_provider.dart';
import '../services/admob_ids.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../creation/virtual_try_on.dart';
import '../home_shell.dart';
import '../pro_access_screen.dart';

/// Result screen for displaying generated floral tattoo
class FlowerResultScreen extends StatefulWidget {
  final String name;
  final Uint8List? generatedImageBytes;
  final bool showProAccessOnOpen;
  final bool enablePaywallPrompts;

  const FlowerResultScreen({
    super.key,
    required this.name,
    this.generatedImageBytes,
    this.showProAccessOnOpen = false,
    this.enablePaywallPrompts = true,
  });

  @override
  State<FlowerResultScreen> createState() => _FlowerResultScreenState();
}

class _FlowerResultScreenState extends State<FlowerResultScreen> {
  bool _didShowPaywallAfterDownload = false;
  bool _didShowInterstitialOnOpen = false;
  static const String _paywallLightAssetPath = 'assets/paywall_light.png';
  static const String _paywallDarkAssetPath = 'assets/paywall_dark.png';
  static const String _fallbackBlurAssetPath = 'assets/asset_blur.png';
  static const String _watermarkLightAssetPath = 'assets/watermark_light.png';
  static const String _watermarkDarkAssetPath = 'assets/watermark_dark.png';

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[FlowerResultScreen] opened (hasImage=${widget.generatedImageBytes != null}, '
      'showProAccessOnOpen=${widget.showProAccessOnOpen})',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didShowInterstitialOnOpen) return;
      if (!widget.enablePaywallPrompts) return;
      if (!widget.showProAccessOnOpen) return;

      final usage = context.read<UsageLimitProvider>();
      if (usage.isProUnlocked) return;

      _didShowInterstitialOnOpen = true;
      await _showInterstitialIfAvailable();
    });
  }

  Future<void> _showInterstitialIfAvailable() async {
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
        onAdFailedToLoad: (_) {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    await completer.future;
  }

  void _openPaywall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProAccessScreen(
          nextScreen: FlowerResultScreen(
            name: widget.name,
            generatedImageBytes: widget.generatedImageBytes,
            showProAccessOnOpen: false,
            enablePaywallPrompts: widget.enablePaywallPrompts,
          ),
          // In Flower Result, paywall close should NOT trigger an ad.
          showInterstitialOnClose: false,
        ),
      ),
    );
  }

  Widget _buildLockedPaywallCard(bool isDark) {
    final paywallAssetPath = isDark
        ? _paywallDarkAssetPath
        : _paywallLightAssetPath;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth * 0.78).clamp(260.0, 480.0);
        final height = (constraints.maxHeight * 0.66).clamp(280.0, 560.0);

        return Center(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                child: Opacity(
                  opacity: 0.72,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Image.asset(
                      paywallAssetPath,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) {
                        return Image.asset(
                          _fallbackBlurAssetPath,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLockedOverlayCard() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 28.h),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 420.w),
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.darkBackground.withOpacity(0.75),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFA6541D), width: 1.2.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Buy Premium to Continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  onPressed: _openPaywall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA6541D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Buy Premium',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textWhite,
                      fontFamily: 'Inter',
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

  Map<String, dynamic> _buildEntry() {
    return {
      'name': widget.name,
      'styleName': '',
      'imageBase64': widget.generatedImageBytes != null
          ? base64Encode(widget.generatedImageBytes!)
          : '',
      'ts': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final usage = context.read<UsageLimitProvider>();
    if (!usage.isProUnlocked && usage.hasReachedFreeLimit) {
      AppToast.show(
        context,
        message: AppLocalizations.of(context)!.buyPremiumToAddToFavourites,
        isSuccess: false,
      );
      return;
    }

    if (widget.generatedImageBytes == null) return;

    final favoritesProvider = Provider.of<FavoritesProvider>(
      context,
      listen: false,
    );
    final entry = _buildEntry();
    final wasFavorited = favoritesProvider.isFavorited(entry);

    final success = await favoritesProvider.toggleFavorite(entry);
    if (!mounted || !success) return;

    final l10n = AppLocalizations.of(context)!;
    AppToast.show(
      context,
      message: wasFavorited ? l10n.favoritesRemoved : l10n.favoritesAdded,
      isSuccess: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final l10n = AppLocalizations.of(context)!;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final usage = context.watch<UsageLimitProvider>();
    final isPro = usage.isProUnlocked;
    final isLocked = !isPro && usage.hasReachedFreeLimit;
    final entry = _buildEntry();
    final isFavorited = favoritesProvider.isFavorited(entry);
    final isLoadingFavorite = favoritesProvider.isLoading;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: Column(
            children: [
              // Header: Close button + Title + Favorite
              _buildHeader(
                context,
                isDark,
                isFavorited,
                isLoadingFavorite,
                isLocked: isLocked,
              ),
              // Main image display
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildMainImage(
                      context,
                      isDark,
                      l10n,
                      isLocked: isLocked,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Action buttons
              Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: bottomPadding > 0 ? bottomPadding : 20.h,
                ),
                child: Column(
                  children: [
                    _buildVirtualTryOnButton(
                      context,
                      isDark,
                      l10n,
                      isPro: isPro,
                    ),
                    SizedBox(height: 12.h),
                    _buildSecondaryButtons(
                      context,
                      isDark,
                      l10n,
                      isPro: isPro,
                      isLocked: isLocked,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    bool isFavorited,
    bool isLoadingFavorite, {
    required bool isLocked,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 28.sp,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
          IconButton(
            icon: isLoadingFavorite
                ? SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  )
                : Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited
                        ? Colors.red
                        : (isDark
                              ? AppColors.textWhite
                              : AppColors.textPrimary),
                    size: 28.sp,
                  ),
            onPressed: () {
              if (isLocked) {
                AppToast.show(
                  context,
                  message: AppLocalizations.of(
                    context,
                  )!.buyPremiumToAddToFavourites,
                  isSuccess: false,
                );
                return;
              }
              _toggleFavorite(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n, {
    required bool isLocked,
  }) {
    final watermarkAssetPath = isDark
        ? _watermarkDarkAssetPath
        : _watermarkLightAssetPath;

    final imageBytes = widget.generatedImageBytes;
    if (imageBytes == null) {
      if (isLocked) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: _buildLockedPaywallCard(isDark)),
            IgnorePointer(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset(
                  watermarkAssetPath,
                  width: 520.w,
                  height: 320.h,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            _buildLockedOverlayCard(),
          ],
        );
      }
      return _buildPlaceholder(isDark, l10n);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final watermarkWidth = (constraints.maxWidth * 1.8).clamp(360.0, 800.0);
        final watermarkHeight = (watermarkWidth * 0.55).clamp(140.0, 320.0);
        // Stable overlay placement across devices:
        // place watermark on top of the generated image area (upper-center).
        final top = (constraints.maxHeight * 0.10).clamp(12.0, 180.0);

        return Stack(
          children: [
            Positioned.fill(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(isDark, l10n);
                },
              ),
            ),
            if (!context.watch<UsageLimitProvider>().isProUnlocked)
              Positioned.fill(
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: top),
                      child: Opacity(
                        opacity: 0.35,
                        child: Image.asset(
                          watermarkAssetPath,
                          width: watermarkWidth,
                          height: watermarkHeight,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPlaceholder(bool isDark, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 400.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.buttonBackground
            : AppColors.textGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported,
              color: AppColors.textGrey,
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.flowerResultFloralTattooFor(widget.name),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGrey,
                fontFamily: 'Amaranth',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualTryOnButton(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n, {
    required bool isPro,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          // Virtual Try On is a premium feature (even for first-time users).
          if (!isPro) {
            _openPaywall();
            return;
          }
          if (widget.generatedImageBytes == null) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VirtualTryOnScreen(
                tattooImageBytes: widget.generatedImageBytes,
                styleName: 'Floral: ${widget.name}',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        child: Text(
          l10n.virtualTryOn,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButtons(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n, {
    required bool isPro,
    required bool isLocked,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            label: l10n.resultShare,
            icon: Icons.share,
            isDark: isDark,
            onTap: () {
              // Share is available for free users until the usage limit is reached.
              if (isLocked) {
                _openPaywall();
                return;
              }
              _shareImage(context);
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSecondaryButton(
            label: l10n.download,
            icon: Icons.download,
            isDark: isDark,
            onTap: () {
              // If free limit is exceeded -> paywall only.
              // If not exceeded -> allow download; paywall is shown after download in `_saveImageToGallery`.
              if (isLocked) {
                _openPaywall();
                return;
              }
              _saveImageToGallery(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.buttonBackground
              : AppColors.textGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.textGrey.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Amaranth',
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareImage(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (widget.generatedImageBytes == null) {
      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.resultNoImageToShare,
          isSuccess: false,
        );
      }
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/floral_tattoo_${widget.name}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(widget.generatedImageBytes!);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: l10n.flowerResultShareText(widget.name),
        subject: l10n.flowerResultShareSubject(widget.name),
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.couldntShareImageTryAgain,
          isSuccess: false,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _saveImageToGallery(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (widget.generatedImageBytes == null) {
      if (context.mounted) {
        AppToast.show(context, message: l10n.noImageToSave, isSuccess: false);
      }
      return;
    }

    try {
      await Gal.putImageBytes(
        widget.generatedImageBytes!,
        name:
            'floral_tattoo_${widget.name}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.resultImageSavedToGallery,
          isSuccess: true,
        );

        final usage = context.read<UsageLimitProvider>();
        if (widget.enablePaywallPrompts &&
            !usage.isProUnlocked &&
            !_didShowPaywallAfterDownload) {
          _didShowPaywallAfterDownload = true;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProAccessScreen(
                nextScreen: HomeShell(),
                showInterstitialOnClose: false,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.couldntSaveImageTryAgain,
          isSuccess: false,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
}
