import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../providers/usage_limit_provider.dart';
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

  const FlowerResultScreen({
    super.key,
    required this.name,
    this.generatedImageBytes,
    this.showProAccessOnOpen = false,
  });

  @override
  State<FlowerResultScreen> createState() => _FlowerResultScreenState();
}

class _FlowerResultScreenState extends State<FlowerResultScreen> {
  bool _didAutoShowPaywall = false;
  bool _didShowPaywallAfterDownload = false;

  @override
  void initState() {
    super.initState();
    debugPrint(
      '[FlowerResultScreen] opened (hasImage=${widget.generatedImageBytes != null}, '
      'showProAccessOnOpen=${widget.showProAccessOnOpen})',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didAutoShowPaywall) return;
      if (!widget.showProAccessOnOpen) {
        debugPrint(
          '[FlowerResultScreen] skip auto paywall: showProAccessOnOpen=false',
        );
        return;
      }
      if (widget.generatedImageBytes == null) {
        debugPrint('[FlowerResultScreen] skip auto paywall: hasImage=false');
        return;
      }

      final usage = context.read<UsageLimitProvider>();
      if (usage.isProUnlocked) {
        debugPrint('[FlowerResultScreen] skip auto paywall: user is PRO');
        return;
      }

      _didAutoShowPaywall = true;
      debugPrint('[FlowerResultScreen] showing ProAccessScreen after loading');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProAccessScreen(
            showInterstitialOnClose: true,
            nextScreen: FlowerResultScreen(
              name: widget.name,
              generatedImageBytes: widget.generatedImageBytes,
              showProAccessOnOpen: false,
            ),
          ),
        ),
      );
    });
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
              // Main image display
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: _buildMainImage(context, isDark, l10n),
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
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainImage(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
  ) {
    if (widget.generatedImageBytes != null) {
      return Image.memory(
        widget.generatedImageBytes!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(isDark, l10n);
        },
      );
    }
    return _buildPlaceholder(isDark, l10n);
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
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: widget.generatedImageBytes != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VirtualTryOnScreen(
                      tattooImageBytes: widget.generatedImageBytes,
                      styleName: 'Floral: ${widget.name}',
                    ),
                  ),
                );
              }
            : null,
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
            onTap: () => _shareImage(context),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSecondaryButton(
            label: l10n.download,
            icon: Icons.download,
            isDark: isDark,
            onTap: () => _saveImageToGallery(context),
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
        if (!usage.isProUnlocked && !_didShowPaywallAfterDownload) {
          _didShowPaywallAfterDownload = true;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProAccessScreen(
                nextScreen: HomeShell(),
                showInterstitialOnClose: true,
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
