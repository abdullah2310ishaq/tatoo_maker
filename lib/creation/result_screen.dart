import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
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

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[ResultScreen] opened (hasImage=${widget.generatedImageBytes != null}, '
      'showProAccessOnOpen=${widget.showProAccessOnOpen})',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didAutoShowPaywall) return;
      if (!widget.showProAccessOnOpen) {
        debugPrint('[ResultScreen] skip auto paywall: showProAccessOnOpen=false');
        return;
      }
      if (widget.generatedImageBytes == null) {
        debugPrint('[ResultScreen] skip auto paywall: hasImage=false');
        return;
      }

      final usage = context.read<UsageLimitProvider>();
      if (usage.isProUnlocked) {
        debugPrint('[ResultScreen] skip auto paywall: user is PRO');
        return;
      }
      if (!mounted || _didAutoShowPaywall) return;
      _didAutoShowPaywall = true;
      debugPrint('[ResultScreen] showing ProAccessScreen after interstitial step');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProAccessScreen(
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
              _buildHeader(context, isDark, isFavorited, isLoadingFavorite),
              // Main image display - only one big image in center
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildMainImage(isDark),
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
                    _buildVirtualTryOnButton(context, isDark, l10n),
                    SizedBox(height: 12.h),
                    _buildSecondaryButtons(context, isDark, l10n),
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
    bool isLoadingFavorite,
  ) {
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
            onPressed: () => Navigator.of(context).pop(),
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
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage(bool isDark) {
    if (widget.generatedImageBytes != null) {
      // Show image directly on background (transparent background)
      return Image.memory(
        widget.generatedImageBytes!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(isDark);
        },
      );
    }
    return _buildPlaceholder(isDark);
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
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
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
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(
            label: l10n.resultShare,
            icon: Icons.share,
            isDark: isDark,
            onTap: () {
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
              builder: (_) => const ProAccessScreen(nextScreen: HomeShell()),
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
