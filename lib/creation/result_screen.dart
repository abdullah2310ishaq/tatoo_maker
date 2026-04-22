import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../utils/toast.dart';
import '../utils/style_localization.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../providers/usage_limit_provider.dart';
import '../home_shell.dart';
import '../pro_access_screen.dart';
import 'virtual_try_on.dart';

class ResultScreen extends StatefulWidget {
  final String styleName;
  final Uint8List? generatedImageBytes;
  final List<Uint8List>? variationImages;
  final String? promptText;
  final bool showProAccessOnOpen;

  const ResultScreen({
    super.key,
    required this.styleName,
    this.generatedImageBytes,
    this.variationImages,
    this.promptText,
    this.showProAccessOnOpen = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _didAutoShowPaywall = false;
  bool _didShowPaywallAfterDownload = false;
  bool _didShowLimitPaywall = false;
  static const String _watermarkLightAssetPath = 'assets/watermark_light.png';
  static const String _watermarkDarkAssetPath = 'assets/watermark_dark.png';
  Size? _generatedImageSize;

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeShell()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _decodeGeneratedImageSize();
    debugPrint(
      '[ResultScreen] opened (hasImage=${widget.generatedImageBytes != null}, '
      'showProAccessOnOpen=${widget.showProAccessOnOpen})',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didAutoShowPaywall) return;
      final usage = context.read<UsageLimitProvider>();

      // When the free usage limit is exceeded, other modules should show only
      // the in-app paywall (no blurred/dummy result UI).
      if (!usage.isProUnlocked && usage.hasExceededFreeLimit && !_didShowLimitPaywall) {
        _didShowLimitPaywall = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ProAccessScreen(
              showInterstitialOnClose: false,
              goToNextScreenOnClose: true,
              nextScreen: HomeShell(),
            ),
          ),
        );
        return;
      }

      if (!widget.showProAccessOnOpen) {
        debugPrint(
          '[ResultScreen] skip auto paywall: showProAccessOnOpen=false',
        );
        return;
      }
      if (widget.generatedImageBytes == null) {
        debugPrint('[ResultScreen] skip auto paywall: hasImage=false');
        return;
      }
      if (usage.isProUnlocked) {
        debugPrint('[ResultScreen] skip auto paywall: user is PRO');
        return;
      }
      if (!mounted || _didAutoShowPaywall) return;
      _didAutoShowPaywall = true;
      debugPrint('[ResultScreen] showing ProAccessScreen after loading');

      // Replace the current ResultScreen so we don't end up with:
      // ResultScreen -> Paywall -> ResultScreen (duplicate stack / double flows).
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProAccessScreen(
            showInterstitialOnClose: true,
            goToNextScreenOnClose: true,
            nextScreen: ResultScreen(
              styleName: widget.styleName,
              generatedImageBytes: widget.generatedImageBytes,
              variationImages: widget.variationImages,
              promptText: widget.promptText,
              showProAccessOnOpen: false,
            ),
          ),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant ResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.generatedImageBytes != widget.generatedImageBytes) {
      _decodeGeneratedImageSize();
    }
  }

  void _decodeGeneratedImageSize() {
    final bytes = widget.generatedImageBytes;
    if (bytes == null) {
      _generatedImageSize = null;
      return;
    }

    try {
      ui.decodeImageFromList(bytes, (image) {
        if (!mounted) return;
        setState(() {
          _generatedImageSize = Size(
            image.width.toDouble(),
            image.height.toDouble(),
          );
        });
      });
    } catch (_) {
      // If decoding fails, we still show watermark using fallback positioning.
      _generatedImageSize = null;
    }
  }

  Map<String, dynamic> _buildEntry() {
    return {
      'styleName': widget.styleName,
      'promptText': widget.promptText ?? '',
      'imageBase64': widget.generatedImageBytes != null
          ? base64Encode(widget.generatedImageBytes!)
          : '',
      'ts': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final usage = context.read<UsageLimitProvider>();
    if (!usage.isProUnlocked && usage.hasExceededFreeLimit) {
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final usage = context.watch<UsageLimitProvider>();
    final isLocked = !usage.isProUnlocked && usage.hasExceededFreeLimit;
    final entry = _buildEntry();
    final isFavorited = favoritesProvider.isFavorited(entry);
    final isLoadingFavorite = favoritesProvider.isLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goHome();
      },
      child: SafeArea(
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
                // Main image display - only one big image in center
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildMainImage(isDark, isLocked: isLocked),
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
                        isLocked: isLocked,
                      ),
                      SizedBox(height: 12.h),
                      _buildSecondaryButtons(
                        context,
                        isDark,
                        l10n,
                        isLocked: isLocked,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
          // Close button
          IconButton(
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textWhite : AppColors.textPrimary,
              size: 28.sp,
            ),
            onPressed: _goHome,
          ),
          // Title (centered) – localized so it updates when app language changes
          Expanded(
            child: Text(
              getLocalizedStyleName(
                AppLocalizations.of(context)!,
                widget.styleName,
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textWhite : AppColors.textPrimary,
                fontFamily: 'Amaranth',
              ),
            ),
          ),
          // Favorite button
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

  Widget _buildMainImage(bool isDark, {required bool isLocked}) {
    final imageBytes = widget.generatedImageBytes;
    if (imageBytes == null) {
      return _buildPlaceholder(isDark);
    }

    return Consumer<UsageLimitProvider>(
      builder: (context, usage, _) {
        final showWatermark = !usage.isProUnlocked;

        return Stack(
          alignment: Alignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final imageWidget = Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder(isDark);
                  },
                );

                final imageSize = _generatedImageSize;
                if (imageSize == null ||
                    constraints.maxWidth <= 0 ||
                    constraints.maxHeight <= 0) {
                  // Fallback: position relative to container.
                  final watermarkAssetPath = isDark
                      ? _watermarkDarkAssetPath
                      : _watermarkLightAssetPath;
                  final watermarkWidth = (constraints.maxWidth * 2.25).clamp(
                    420.0,
                    1100.0,
                  );
                  final watermarkHeight = (watermarkWidth * 0.82).clamp(
                    180.0,
                    520.0,
                  );
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(child: imageWidget),
                      if (showWatermark)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: (constraints.maxHeight * 0.15).clamp(
                                    60.0,
                                    300.0,
                                  ),
                                ),
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
                }

                // The watermark uses stable placement relative to container size.

                final watermarkAssetPath = isDark
                    ? _watermarkDarkAssetPath
                    : _watermarkLightAssetPath;
                final watermarkWidth = (constraints.maxWidth * 2.25).clamp(
                  420.0,
                  1100.0,
                );
                final watermarkHeight = (watermarkWidth * 0.82).clamp(
                  180.0,
                  520.0,
                );
                // Stable overlay placement across devices (upper-center).
                final top = (constraints.maxHeight * 0.15).clamp(60.0, 300.0);

                return Stack(
                  children: [
                    Positioned.fill(child: imageWidget),
                    if (showWatermark)
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
            ),
          ],
        );
      },
    );
  }

  void _openPaywall() {
    if (!mounted) return;
    final usage = context.read<UsageLimitProvider>();
    final hasReachedLimit = !usage.isProUnlocked && usage.hasExceededFreeLimit;

    // When free limit is reached, exiting the paywall must take user home
    // (no "locked/dummy" result UI for Creation/Tattoo modules).
    if (hasReachedLimit) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ProAccessScreen(
            showInterstitialOnClose: false,
            goToNextScreenOnClose: true,
            nextScreen: HomeShell(),
          ),
        ),
      );
      return;
    }

    // Otherwise, paywall can return back to this result screen.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProAccessScreen(
          showInterstitialOnClose: true,
          nextScreen: ResultScreen(
            styleName: widget.styleName,
            generatedImageBytes: widget.generatedImageBytes,
            variationImages: widget.variationImages,
            promptText: widget.promptText,
            showProAccessOnOpen: false,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
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
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.textGrey,
          size: 64.sp,
        ),
      ),
    );
  }

  // Commented out for now - variation carousel
  // Widget _buildVariationCarousel(bool isDark) {
  //   // For now, show placeholder thumbnails
  //   // Later, you can use variationImages if available
  //   final thumbnails = List.generate(3, (index) => index);

  //   return SizedBox(
  //     height: 120,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //       itemCount: thumbnails.length,
  //       itemBuilder: (context, index) {
  //         final isActive = index == 0;
  //         final isPro = index > 0;

  //         return Padding(
  //           padding: EdgeInsets.only(
  //             right: index < thumbnails.length - 1 ? 12 : 0,
  //           ),
  //           child: _buildThumbnail(
  //             isDark: isDark,
  //             isActive: isActive,
  //             isPro: isPro,
  //             imageBytes: index == 0 ? generatedImageBytes : null,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Commented out - only used by variation carousel
  // Widget _buildThumbnail({
  //   required bool isDark,
  //   required bool isActive,
  //   required bool isPro,
  //   Uint8List? imageBytes,
  // }) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Handle thumbnail tap - switch main image
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: isActive
  //               ? AppColors.cardGlowStart
  //               : AppColors.textGrey.withOpacity(0.3),
  //           width: isActive ? 2 : 1,
  //         ),
  //       ),
  //       child: Stack(
  //         children: [
  //           // Image or placeholder
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(12),
  //             child: imageBytes != null
  //                 ? Image.memory(
  //                     imageBytes,
  //                     width: 100,
  //                     height: 100,
  //                     fit: BoxFit.cover,
  //                   )
  //                 : Container(
  //                     width: 100,
  //                     height: 100,
  //                     color: isDark
  //                         ? AppColors.buttonBackground
  //                         : AppColors.textGrey.withOpacity(0.1),
  //                     child: Icon(
  //                       Icons.image,
  //                       color: AppColors.textGrey,
  //                       size: 32,
  //                     ),
  //                   ),
  //           ),
  //           // Pro badge
  //           if (isPro)
  //             Positioned(
  //               top: 4,
  //               right: 4,
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 6,
  //                   vertical: 2,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.cardGlowStart,
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: Text(
  //                   'Pro',
  //                   style: TextStyle(
  //                     fontSize: 10,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.white,
  //                     fontFamily: 'Amaranth',
  //                   ),
  //                 ),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVirtualTryOnButton(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n, {
    required bool isLocked,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          if (isLocked) {
            _openPaywall();
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VirtualTryOnScreen(
                tattooImageBytes: widget.generatedImageBytes,
                styleName: widget.styleName,
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
              if (isLocked) {
                _openPaywall();
                return;
              }
              _shareImage(context, l10n); // Direct share, no bottom sheet
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
              if (isLocked) {
                _openPaywall();
                return;
              }
              _saveImageToGallery(context, l10n);
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

  Future<void> _shareImage(BuildContext context, AppLocalizations l10n) async {
    if (widget.generatedImageBytes == null) {
      AppToast.show(
        context,
        message: l10n.resultNoImageToShare,
        isSuccess: false,
      );
      return;
    }

    try {
      // Save image to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/inkvision_${widget.styleName}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(widget.generatedImageBytes!);

      // Share the image file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: l10n.resultShareText(widget.styleName),
        subject: l10n.resultShareSubject(widget.styleName),
      );
    } catch (e) {
      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.resultErrorSharing(e.toString()),
          isSuccess: false,
        );
      }
    }
  }

  Future<void> _saveImageToGallery(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (widget.generatedImageBytes == null) {
      AppToast.show(context, message: l10n.noImageToSave, isSuccess: false);
      return;
    }

    try {
      await Gal.putImageBytes(
        widget.generatedImageBytes!,
        name:
            'inkvision_${widget.styleName}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.resultImageSavedToGallery,
          isSuccess: true,
        );

        final usage = context.read<UsageLimitProvider>();
        if (!usage.isProUnlocked && !_didShowPaywallAfterDownload) {
          _didShowPaywallAfterDownload = true;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProAccessScreen(
                nextScreen: HomeShell(),
                // Download upsell should close without any ad.
                showInterstitialOnClose: false,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.show(
          context,
          message: l10n.resultErrorSaving(e.toString()),
          isSuccess: false,
        );
      }
    }
  }
}
