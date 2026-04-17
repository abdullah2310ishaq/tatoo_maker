import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
// import '../../../providers/usage_limit_provider.dart';
// import '../../../services/admob_ids.dart';
// import '../../../services/remote_config_service.dart';
import '../../../utils/colors.dart';
import '../../../widgets/remote_or_asset_image.dart';
import '../models/onboarding_models.dart';
import '../utils/zodiac_utils.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';

class StepStyleSelectionPage extends StatefulWidget {
  final int? selectedStyleIndex;
  final ValueChanged<int?> onStyleSelected;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepStyleSelectionPage({
    super.key,
    required this.selectedStyleIndex,
    required this.onStyleSelected,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepStyleSelectionPage> createState() => _StepStyleSelectionPageState();
}

class _StepStyleSelectionPageState extends State<StepStyleSelectionPage> {
  // Ads are intentionally disabled on this step.
  // Keep the implementation commented for quick re-enable.
  // bool _bannerLoaded = false;
  // bool _nativeLoaded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final styles = getTattooStyles(context, isDark);

    // --- ADS DISABLED (kept for quick re-enable) ---
    // final rc = context.watch<RemoteConfigService>();
    // final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    // final shouldShowBanner = !isPro && rc.tattooStyleSelectionShowBanner;
    // final shouldShowNative = !isPro && rc.tattooStyleSelectionShowNative;
    //
    // if (!shouldShowBanner && _bannerLoaded) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (!mounted) return;
    //     if (_bannerLoaded) setState(() => _bannerLoaded = false);
    //   });
    // }
    // if (!shouldShowNative && _nativeLoaded) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (!mounted) return;
    //     if (_nativeLoaded) setState(() => _nativeLoaded = false);
    //   });
    // }
    //
    // final adsActuallyVisible = _bannerLoaded || _nativeLoaded;
    // final styleRowHeight = adsActuallyVisible ? 225.h : 190.h;

    final styleRowHeight = 190.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingHeader(currentStep: 5, onBack: widget.onBack),
        // Ads intentionally disabled.
        // if (shouldShowBanner) ...[
        //   _StyleSelectionBannerAd(
        //     unitId: AdmobIds.bannerUnitId(),
        //     onVisibilityChanged: (visible) {
        //       if (_bannerLoaded == visible) return;
        //       setState(() => _bannerLoaded = visible);
        //     },
        //   ),
        //   if (_bannerLoaded) SizedBox(height: 12.h),
        // ],
        SizedBox(height: 40.h),
        // Question
        Text(
          AppLocalizations.of(context)!.stepStylePickYourTitleStyle,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Amaranth',
          ),
        ),
        SizedBox(height: 30.h),
        // Style selection
        SizedBox(
          height: styleRowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: styles.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final item = styles[index];
              final bool isSelected = widget.selectedStyleIndex == index;
              return _buildStyleCard(item, index, isSelected, isDark);
            },
          ),
        ),
        const Spacer(),
        // Native ad disabled on this step; keep only banner ad.
        // if (shouldShowNative) ...[
        //   _StyleSelectionNativeAd(
        //     isDark: isDark,
        //     onVisibilityChanged: (visible) {
        //       if (_nativeLoaded == visible) return;
        //       setState(() => _nativeLoaded = visible);
        //     },
        //   ),
        //   // Keep it close to the button (more down) without leaving gaps when hidden.
        //   if (_nativeLoaded) SizedBox(height: 6.h),
        // ],
        // Next button
        OnboardingNextButton(
          enabled: widget.selectedStyleIndex != null,
          isLastStep: true,
          onPressed: widget.onNext,
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildStyleCard(
    TattooStyleItem item,
    int index,
    bool isSelected,
    bool isDark,
  ) {
    final double width = isSelected ? 150.w : 130.w;
    final Color borderColor = isSelected
        ? const Color(0xFFFE8B3A)
        : AppColors.cardGradientEnd;
    final cardBgColor = isDark
        ? const Color(0xFF151411)
        : AppColors.lightCardBackground;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.4.w),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          widget.onStyleSelected(isSelected ? null : index);
        },
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: RemoteOrAssetImage(
                    assetPath: item.assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ADS DISABLED (kept for quick re-enable) ---
/*
/// Dedicated banner ad for style-selection step (page-specific implementation).
class _StyleSelectionBannerAd extends StatefulWidget {
  const _StyleSelectionBannerAd({
    required this.unitId,
    required this.onVisibilityChanged,
  });

  final String unitId;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_StyleSelectionBannerAd> createState() =>
      _StyleSelectionBannerAdState();
}

class _StyleSelectionBannerAdState extends State<_StyleSelectionBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    widget.onVisibilityChanged(visible);
  }

  void _loadAd() {
    final unitId = widget.unitId.trim();
    if (unitId.isEmpty) return;

    final ad = BannerAd(
      adUnitId: unitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as BannerAd;
            _loaded = true;
          });
          _emit(true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
          _emit(false);
        },
      ),
    );

    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _emit(false);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !_loaded || _ad == null) {
      _emit(false);
      return const SizedBox.shrink();
    }

    _emit(true);
    return SafeArea(
      bottom: false,
      child: Center(
        child: SizedBox(
          width: _ad!.size.width.toDouble(),
          height: _ad!.size.height.toDouble(),
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
*/

// Native ad intentionally disabled in this step.
// Keep this code commented for quick re-enable if needed.
/*
/// Dedicated native ad for style-selection step (page-specific implementation).
class _StyleSelectionNativeAd extends StatefulWidget {
  const _StyleSelectionNativeAd({
    required this.isDark,
    required this.onVisibilityChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_StyleSelectionNativeAd> createState() =>
      _StyleSelectionNativeAdState();
}

class _StyleSelectionNativeAdState extends State<_StyleSelectionNativeAd> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void didUpdateWidget(covariant _StyleSelectionNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    _emit(false);
    _loadAd();
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    widget.onVisibilityChanged(visible);
  }

  void _loadAd() {
    final unitId = AdmobIds.nativeUnitId();
    if (unitId.isEmpty) return;

    final ad = NativeAd(
      adUnitId: unitId,
      request: const AdRequest(),
      factoryId: 'listTileLanguage',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as NativeAd;
            _loaded = true;
          });
          _emit(true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
          _emit(false);
        },
      ),
    );

    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _emit(false);
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    final slotH = 120.h;

    if (isPro) {
      _emit(false);
      return const SizedBox.shrink();
    }

    if (!_loaded || _ad == null) {
      _emit(false);
      return SizedBox(height: slotH);
    }

    _emit(true);

    final cardColor = widget.isDark
        ? AppColors.inputCardDarkBackground
        : AppColors.lightBackground;
    final radius = BorderRadius.circular(14.r);

    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Material(
        color: cardColor,
        elevation: 4,
        shadowColor: AppColors.toastShadow,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: slotH,
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
*/
