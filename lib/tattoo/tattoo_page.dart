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
import 'onboarding_flow.dart';

const double kTattooVideoSectionHeight = 350;
const double kTattooVideoSectionWidth = 400;

class TattooPage extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onHistoryTap;

  const TattooPage({super.key, this.onMenuTap, this.onHistoryTap});

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
                    // Dark: video.mp4; light: video_light.mp4
                    _buildVideoArea(
                      context,
                      assetPath: isDark
                          ? 'assets/video.mp4'
                          : 'assets/video_light.mp4',
                    ),
                    SizedBox(height: 40.h),
                    // Welcome text
                    _buildWelcomeText(context, isDark),
                  ],
                ),
              ),
              // Continue button - little above navbar
              _buildContinueButton(context, isDark),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoArea(BuildContext context, {required String assetPath}) {
    return SizedBox(
      height: kTattooVideoSectionHeight.h,
      width: kTattooVideoSectionWidth.w,
      child: _TattooPageVideo(
        assetPath: assetPath,
        sectionHeight: kTattooVideoSectionHeight,
        sectionWidth: kTattooVideoSectionWidth,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isDark}) {
    final iconColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final buttonBgColor = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);
    final menuIconAsset = isDark
        ? 'assets/drawer_dark.svg'
        : 'assets/drawer_light.svg';
    final historyIconAsset = isDark
        ? 'assets/history_dark.svg'
        : 'assets/history_light.svg';
    final double menuSize = isDark ? 50.w : 60.w;
    final double historySize = isDark ? 50.w : 60.w;

    // LTR so menu stays left and history right (same as English) in Arabic
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button (left)
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              menuIconAsset,
              width: menuSize,
              height: menuSize,
              placeholderBuilder: (context) =>
                  Icon(Icons.menu, color: iconColor, size: 32.sp),
            ),
            onPressed: onMenuTap,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Tattoo',
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
          // History button (right)
          IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              historyIconAsset,
              width: historySize,
              height: historySize,
              placeholderBuilder: (context) =>
                  Icon(Icons.history, color: iconColor, size: 32.sp),
            ),
            onPressed: onHistoryTap,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.tattooPageTurnYourNameIntoA,
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
          l10n.tattooPageOneOfAKindTattoo,
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

  Widget _buildContinueButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const OnboardingFlow()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA6541D), // Burnt orange
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.continue_,
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

/// Plays an asset video in a loop. Used on tattoo page in dark mode.
class _TattooPageVideo extends StatefulWidget {
  final String assetPath;
  final double sectionHeight;
  final double? sectionWidth;

  const _TattooPageVideo({
    required this.assetPath,
    this.sectionHeight = 200,
    this.sectionWidth,
  });

  @override
  State<_TattooPageVideo> createState() => _TattooPageVideoState();
}

class _TattooPageVideoState extends State<_TattooPageVideo> {
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
  void didUpdateWidget(covariant _TattooPageVideo oldWidget) {
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
            debugPrint('TattooPage video failed to load: $e');
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

  @override
  Widget build(BuildContext context) {
    final h = widget.sectionHeight.h;
    final w = widget.sectionWidth == null
        ? double.infinity
        : widget.sectionWidth!.w;

    if (_initError) {
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: AppColors.cardGradientStart.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Icon(
            Icons.broken_image,
            color: AppColors.textGrey,
            size: 48.sp,
          ),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      // No fallback while loading: keep it transparent for 1 second to avoid flicker.
      if (!_showLoadingPlaceholder) {
        return SizedBox(height: h, width: w);
      }

      // After 1s, show a subtle placeholder only if it still isn't ready.
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
