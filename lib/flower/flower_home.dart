import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';
import '../l10n/app_localizations.dart';
import '../utils/colors.dart';
import '../utils/theme_manager.dart';
import '../widgets/inkvision_underline.dart';
import '../widgets/asset_video_controller_cache.dart';
import 'flower_input_screen.dart';

/// Video section size on flower home. Adjust to change player area.
const double kFlowerVideoSectionHeight = 350;
const double? kFlowerVideoSectionWidth = null;

class FlowerHome extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onHistoryTap;

  const FlowerHome({super.key, this.onMenuTap, this.onHistoryTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        decoration: isDark
            ? BoxDecoration(color: AppColors.darkBackground)
            : ThemeManager.lightModeBackground,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              // Header: menu + InkVision + notification
              _buildHeader(context, isDark: isDark),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    // Dark: one_dark.mp4; light: one_light.mp4
                    _buildVideoArea(
                      context,
                      assetPath: isDark
                          ? 'assets/one_dark.mp4'
                          : 'assets/one_light.mp4',
                    ),
                    SizedBox(height: 40.h),
                    // Welcome text
                    _buildWelcomeText(context, isDark),
                  ],
                ),
              ),
              // Create button - little above navbar
              _buildCreateButton(context, isDark),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoArea(BuildContext context, {required String assetPath}) {
    return SizedBox(
      height: kFlowerVideoSectionHeight.h,
      width: kFlowerVideoSectionWidth == null
          ? double.infinity 
          : kFlowerVideoSectionWidth!.w,
      child: _FlowerHomeVideo(
        assetPath: assetPath,
        sectionHeight: kFlowerVideoSectionHeight,
        sectionWidth: kFlowerVideoSectionWidth,
        fallbackImagePath: 'assets/flower/input.png',
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isDark}) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final buttonBgColor = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Menu button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/one.svg',
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 24.sp),
            ),
            onPressed: onMenuTap,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'InkVision',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textWhite
                      : AppColors.darkBackground,
                  fontFamily: 'Tomorrow',
                ),
              ),
              SizedBox(height: 6.h),
              InkVisionUnderline(width: 120.w, height: 3.h),
            ],
          ),
        ),
        // History button
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: buttonBgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(Icons.history, color: iconColor, size: 24.sp),
            onPressed: onHistoryTap,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.flowerHomeTransformYourName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.flowerHomeIntoABouquetTattoo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
            fontFamily: 'Amaranth',
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FlowerInputScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.flowerHomeCreate,
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
}

/// Plays an asset video in a loop. Used on flower home for light/dark theme.
/// If video fails (e.g. codec/format), shows [fallbackImagePath] when set.
class _FlowerHomeVideo extends StatefulWidget {
  final String assetPath;
  final double sectionHeight;
  final double? sectionWidth;
  final String? fallbackImagePath;

  const _FlowerHomeVideo({
    required this.assetPath,
    this.sectionHeight = 350,
    this.sectionWidth,
    this.fallbackImagePath,
  });

  @override
  State<_FlowerHomeVideo> createState() => _FlowerHomeVideoState();
}

class _FlowerHomeVideoState extends State<_FlowerHomeVideo> {
  late VideoPlayerController _controller;
  bool _initError = false;
  bool _hadValidSize = false;
  String _currentAssetPath = '';
  bool _showLoadingPlaceholder = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _currentAssetPath = widget.assetPath;
    _initController();
    _scheduleLoadingPlaceholder();
  }

  @override
  void didUpdateWidget(covariant _FlowerHomeVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _controller.removeListener(_onControllerUpdate);
      _currentAssetPath = widget.assetPath;
      _initError = false;
      _hadValidSize = false;
      _showLoadingPlaceholder = false;
      _initController();
      _scheduleLoadingPlaceholder();
    }
  }

  void _initController() {
    _controller = AssetVideoControllerCache.controllerFor(_currentAssetPath);
    _controller.addListener(_onControllerUpdate);
    AssetVideoControllerCache.ensureInitialized(_currentAssetPath)
        .then((_) {
          if (mounted && !_initError) setState(() {});
        })
        .catchError((Object e) {
          if (kDebugMode) {
            debugPrint('FlowerHome video failed to load: $e');
          }
          if (mounted) {
            setState(() => _initError = true);
          }
        });
  }

  void _scheduleLoadingPlaceholder() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || _disposed) return;
      if (!_initError && !_controller.value.isInitialized) {
        setState(() => _showLoadingPlaceholder = true);
      }
    });
  }

  void _onControllerUpdate() {
    if (!mounted || !_controller.value.isInitialized) return;
    final size = _controller.value.size;
    if (!_hadValidSize && size.width > 0 && size.height > 0) {
      _hadValidSize = true;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _disposed = true;
    try {
      if (_controller.value.isPlaying) {
        _controller.pause();
      }
    } catch (_) {
      // Ignore pause errors.
    }
    _controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  Widget _buildErrorPlaceholder(double h, double w) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: AppColors.cardGradientStart.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(
          _initError ? Icons.broken_image : Icons.videocam_off,
          color: AppColors.textGrey,
          size: 48.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.sectionHeight.h;
    final w = widget.sectionWidth == null
        ? double.infinity
        : widget.sectionWidth!.w;

    if (_initError) {
      if (widget.fallbackImagePath != null &&
          widget.fallbackImagePath!.isNotEmpty) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: h,
            width: w,
            child: Image.asset(
              widget.fallbackImagePath!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _buildErrorPlaceholder(h, w),
            ),
          ),
        );
      }
      return _buildErrorPlaceholder(h, w);
    }

    if (!_controller.value.isInitialized) {
      // No fallback while loading: transparent for 1 second to avoid flicker.
      if (!_showLoadingPlaceholder) {
        return SizedBox(height: h, width: w);
      }

      // After 1s, keep a subtle placeholder only if it still isn't ready.
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: AppColors.cardGradientStart.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
        ),
      );
    }

    // If the controller is initialized but not currently playing (for example,
    // after switching tabs or returning to this page), ensure it resumes.
    if (!_controller.value.isPlaying) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted || !_controller.value.isInitialized) return;
        try {
          if (!_controller.value.isLooping) {
            await _controller.setLooping(true);
          }
          await _controller.play();
        } catch (_) {
          // Ignore playback errors; UI will still show the last frame.
        }
      });
    }
    final size = _controller.value.size;
    final ratio = (size.width > 0 && size.height > 0)
        ? (size.width / size.height)
        : 16 / 9;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: w,
        height: h,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox(
            width: 160,
            height: 160 / ratio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
