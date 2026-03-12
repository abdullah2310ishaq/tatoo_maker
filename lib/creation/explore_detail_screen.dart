import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import 'loading_screen.dart';
import 'virtual_try_on.dart';

class ExploreDetailScreen extends StatefulWidget {
  final String title;
  final String prompt;
  final String bigImagePath;
  final String? smallImagePath;
  final String? smallImagePathDark;

  /// Stable key (e.g. 'exploreItemMinimalistPanda') stored in history
  /// so the title can be re-localized on language change.
  final String? styleKey;

  const ExploreDetailScreen({
    super.key,
    required this.title,
    required this.prompt,
    required this.bigImagePath,
    this.smallImagePath,
    this.smallImagePathDark,
    this.styleKey,
  });

  @override
  State<ExploreDetailScreen> createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  bool _isLoadingImageBytes = false;

  /// Converts an asset image to Uint8List bytes
  Future<Uint8List?> _loadAssetImageBytes(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      return data.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error loading asset image: $e');
      return null;
    }
  }

  /// Navigates to Virtual Try On screen with the asset image
  Future<void> _navigateToVirtualTryOn() async {
    if (_isLoadingImageBytes) return;

    setState(() {
      _isLoadingImageBytes = true;
    });

    try {
      // Prefer the same small image used in the detailed view (dark/light),
      // fall back to the big image if needed.
      final isDark = Theme.of(context).brightness == Brightness.dark;
      String assetPath;
      if (isDark && widget.smallImagePathDark != null) {
        assetPath = widget.smallImagePathDark!;
      } else if (widget.smallImagePath != null) {
        assetPath = widget.smallImagePath!;
      } else {
        assetPath = widget.bigImagePath;
      }

      final imageBytes = await _loadAssetImageBytes(assetPath);

      if (!mounted) return;

      if (imageBytes != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VirtualTryOnScreen(
              tattooImageBytes: imageBytes,
              styleName: widget.styleKey ?? widget.title,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.virtualTryOnProcessingFailedTryAgain),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to virtual try on: $e');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.virtualTryOnProcessingFailedTryAgain),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingImageBytes = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final promptTextColor = isDark ? Colors.white70 : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: isDark
              ? ThemeManager.darkModeBackgroundGradient
              : ThemeManager.lightModeBackground,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // On sufficiently tall screens, keep the page static (no scrolling).
              // On very small screens, fall back to a scrollable layout to avoid overflows.
              final bool isTallScreen = constraints.maxHeight >= 700.h;

              final content = Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Header: X icon on left, title centered
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 16.h),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Close icon on left
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: iconColor,
                              size: 28.sp,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        // Title centered - full text, no truncation, wraps dynamically
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.w),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                                fontFamily: 'Amaranth',
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Asset image centered below X (fixed smaller size) - clickable for virtual try on
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _navigateToVirtualTryOn,
                        child: SizedBox(
                          width: 265.w, // Fixed width
                          height: 265.w, // Fixed height (square)
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildImageAsset(
                                context,
                                widget.smallImagePath,
                                widget.smallImagePathDark,
                                widget.bigImagePath,
                                isDark,
                              ),
                              if (_isLoadingImageBytes)
                                Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.cardGlowStart,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Prompt Detail Card (styled like homepage input card) - Fixed height with scrollable content
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Prompt" label
                        Text(
                          l10n.promptLabel,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontFamily: 'Amaranth',
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Prompt card with orange glow - Fixed height with scrollable content
                        Container(
                          width: double.infinity,
                          height: 170.h, // Slightly reduced fixed height
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.titleGradientStart,
                              width: 1.w,
                            ),
                            color: cardBgColor,
                            gradient: cardGradient,
                          ),
                          child: Stack(
                            children: [
                              // Orange glow in top-right corner (only in dark mode)
                              if (isDark)
                                Positioned(
                                  top: -60.h,
                                  right: -60.w,
                                  child: IgnorePointer(
                                    child: Container(
                                      width: 180.w,
                                      height: 180.h,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          center: Alignment.topRight,
                                          radius: 0.9,
                                          colors: [
                                            AppColors.cardGlowStart,
                                            AppColors.cardGlowEnd,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              // Scrollable prompt text
                              SingleChildScrollView(
                                child: Text(
                                  widget.prompt,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: promptTextColor,
                                    fontFamily: 'Amaranth',
                                    height: 1.5,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Action buttons: "Try This" and "Virtual Try On"
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: bottomPadding > 0 ? bottomPadding : 16.h,
                    ),
                    child: Column(
                      children: [
                        // "Try This" button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                    selectedStyleAsset: widget.bigImagePath,
                                    styleName: widget.styleKey ?? widget.title,
                                    promptText: widget.prompt,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFA6541D,
                              ), // Burnt orange
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8.r,
                                ), // Stadium shape
                              ),
                            ),
                            child: Text(
                              l10n.tryThis,
                              style: TextStyle(
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Amaranth',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // "Virtual Try On" button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: _isLoadingImageBytes
                                ? null
                                : _navigateToVirtualTryOn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFA6541D,
                              ), // Burnt orange
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: _isLoadingImageBytes
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    l10n.virtualTryOn,
                                    style: TextStyle(
                                      fontSize: 23.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: 'Amaranth',
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (isTallScreen) {
                return content;
              }

              return SingleChildScrollView(child: content);
            },
          ),
        ),
      ),
    );
  }

  /// Builds the image asset, automatically using dark version in dark theme
  Widget _buildImageAsset(
    BuildContext context,
    String? smallImagePath,
    String? smallImagePathDark,
    String bigImagePath,
    bool isDark,
  ) {
    if (isDark && smallImagePathDark != null) {
      // Use explicit dark image path if provided
      return Image.asset(
        smallImagePathDark,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to light image if dark doesn't exist
          if (smallImagePath != null) {
            return Image.asset(
              smallImagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(bigImagePath, fit: BoxFit.contain);
              },
            );
          }
          return Image.asset(bigImagePath, fit: BoxFit.contain);
        },
      );
    } else if (smallImagePath != null) {
      // Use light image path (or fallback for dark theme if no dark path provided)
      return Image.asset(
        smallImagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(bigImagePath, fit: BoxFit.contain);
        },
      );
    } else {
      // No small image, use big image
      return Image.asset(bigImagePath, fit: BoxFit.contain);
    }
  }
}
