import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/usage_limit_provider.dart';
import '../../../services/ad_request_factory.dart';
import '../../../services/admob_ids.dart';
import '../../../services/remote_config_service.dart';
import '../../../services/native_ad_service.dart';
import '../../../utils/colors.dart';
import '../widgets/onboarding_header.dart';

class StepTattooIdeaPage extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const StepTattooIdeaPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<StepTattooIdeaPage> createState() => _StepTattooIdeaPageState();
}

class _StepTattooIdeaPageState extends State<StepTattooIdeaPage> {
  static const int _maxCharacters = 500;
  final FocusNode _ideaFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant StepTattooIdeaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_handleTextChanged);
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    _ideaFocusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textWhite : AppColors.textPrimary;
    final cardBgColor = isDark ? null : AppColors.lightBackground;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.cardGradientStart, AppColors.cardGradientEnd],
          )
        : null;
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    final canShowBanner = !isPro && rc.tattooIdeaShowBanner;
    final canShowNative = !isPro && rc.tattooIdeaShowNative;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OnboardingHeader(
                    currentStep: 3,
                    onBack: widget.onBack,
                    trailing: Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: _IdeaNextTopRightButton(
                        enabled: widget.controller.text.trim().isNotEmpty,
                        onPressed: widget.onNext,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.stepTattooIdeaWhatYourTattooIdea,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Amaranth',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    constraints: BoxConstraints(minHeight: 150.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.titleGradientStart,
                        width: 1.w,
                      ),
                      color: cardBgColor,
                      gradient: cardGradient,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: TextField(
                          controller: widget.controller,
                          focusNode: _ideaFocusNode,
                          onTapOutside: (_) => _ideaFocusNode.unfocus(),
                          maxLength: _maxCharacters,
                          maxLines: null,
                          minLines: 6,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(fontSize: 14.sp, color: textColor),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            )!.stepTattooIdeaHint,
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textGrey,
                            ),
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
        // Collapsible banners are far more likely to be served when the ad
        // placement stays stable and doesn't get removed/re-mounted (e.g. on
        // keyboard open/close). So we keep this bottom slot mounted and simply
        // decide which ad type occupies it.
        if (canShowBanner) ...[
          const _TattooIdeaBannerAd(),
          SafeArea(top: false, child: SizedBox(height: 8.h)),
        ] else if (canShowNative) ...[
          _TattooIdeaNativeAd(isDark: isDark),
          SafeArea(top: false, child: SizedBox(height: 8.h)),
        ] else ...[
          // Keep a tiny bottom padding to match layout.
          SafeArea(top: false, child: SizedBox(height: 12.h)),
        ],
      ],
    );
  }
}

class _TattooIdeaBannerAd extends StatefulWidget {
  const _TattooIdeaBannerAd();

  @override
  State<_TattooIdeaBannerAd> createState() => _TattooIdeaBannerAdState();
}

class _TattooIdeaBannerAdState extends State<_TattooIdeaBannerAd> {
  BannerAd? _ad;
  bool _isLoadedBannerAd = false;
  bool _isLoadingBannerAd = false;
  int _requestedWidth = 0;
  int _scheduledWidth = 0;

  @override
  void initState() {
    super.initState();
    // Load is triggered from build via LayoutBuilder to ensure we always have a
    // real width and to avoid coupling to MediaQuery in initState.
  }

  Future<void> _loadForWidth(int width) async {
    if (!mounted) return;

    final rc = context.read<RemoteConfigService>();
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;

    if (isPro || !rc.tattooIdeaShowBanner) {
      _disposeAd();
      return;
    }

    if (width <= 0) return;

    // Skip if we already have (or are loading) a banner for this width.
    if (_requestedWidth == width && (_isLoadingBannerAd || _isLoadedBannerAd)) {
      return;
    }

    _scheduledWidth = 0;
    _requestedWidth = width;

    // Set loading flag BEFORE any await
    if (mounted) setState(() => _isLoadingBannerAd = true);

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (!mounted) return;

    if (size == null) {
      setState(() {
        _isLoadingBannerAd = false;
        _isLoadedBannerAd = false;
      });
      return;
    }

    // Dispose old ad only when recreating due to width/orientation change.
    _disposeAd();

    // _disposeAd() resets flags; re-arm them so concurrent triggers can't sneak
    // in while the new banner is still loading.
    _isLoadingBannerAd = true;
    _requestedWidth = width;

    final banner = BannerAd(
      adUnitId: AdmobIds.collapsibleBannerUnitId().trim(),
      request: AdRequestFactory.collapsibleBottom(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            final bannerAd = ad as BannerAd;
            try {
              final isCollapsible =
                  (bannerAd as dynamic).isCollapsible as bool? ?? false;
              debugPrint(
                'TattooIdea banner loaded: ${isCollapsible ? "" : "not "}collapsible.',
              );
            } catch (_) {
              debugPrint('TattooIdea banner loaded.');
            }
          }
          if (!mounted) return;
          setState(() {
            _ad = ad as BannerAd;
            _isLoadedBannerAd = true;
            _isLoadingBannerAd = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _isLoadedBannerAd = false;
            _isLoadingBannerAd = false;
          });
        },
      ),
    );

    _ad = banner;
    banner.load();
  }

  void _disposeAd() {
    _ad?.dispose();
    _ad = null;
    _isLoadedBannerAd = false;
    _isLoadingBannerAd = false;
    _requestedWidth = 0;
    _scheduledWidth = 0;
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;

    if (isPro || !rc.tattooIdeaShowBanner) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth.truncate()
            : MediaQuery.of(context).size.width.truncate();

        // Trigger load only when needed and never on keyboard open/close
        // (this widget stays mounted in the tree).
        if (width > 0 &&
            _requestedWidth != width &&
            !_isLoadingBannerAd &&
            _scheduledWidth != width) {
          _scheduledWidth = width;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            unawaited(_loadForWidth(width));
          });
        }

        final ad = _ad;
        if (!_isLoadedBannerAd || ad == null) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          child: Center(
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        );
      },
    );
  }
}

class _TattooIdeaNativeAd extends StatefulWidget {
  const _TattooIdeaNativeAd({required this.isDark});

  final bool isDark;

  @override
  State<_TattooIdeaNativeAd> createState() => _TattooIdeaNativeAdState();
}

class _TattooIdeaNativeAdState extends State<_TattooIdeaNativeAd> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final rc = context.read<RemoteConfigService>();
      final isPro = context.read<UsageLimitProvider>().isProUnlocked;
      if (isPro || !rc.tattooIdeaShowNative) return;
      final cardColor = AppColors.gradientBottom;
      unawaited(
        NativeAdService.instance.preload(
          backgroundColor: cardColor.value,
          isDark: true,
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant _TattooIdeaNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    final cardColor = AppColors.gradientBottom;
    unawaited(
      NativeAdService.instance.ensureLoaded(
        backgroundColor: cardColor.value,
        isDark: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowNative) {
      return const SizedBox.shrink();
    }

    final nativeService = context.watch<NativeAdService>();
    final ad = nativeService.ad;
    if (!nativeService.isLoaded || ad == null) {
      return const SizedBox.shrink();
    }

    final cardColor = AppColors.gradientBottom;
    final radius = BorderRadius.circular(14.r);
    final slotHeight = 290.h;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: cardColor,
        elevation: 4,
        shadowColor: AppColors.toastShadow,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: slotHeight,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}

class _IdeaNextTopRightButton extends StatelessWidget {
  const _IdeaNextTopRightButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabledBackground = AppColors.darkPrimary;
    final disabledBackground = isDark
        ? AppColors.buttonBackground
        : AppColors.textGrey.withOpacity(0.1);
    final enabledText = AppColors.textWhite;
    final disabledText = AppColors.textGrey;

    return SizedBox(
      height: 44.h,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? enabledBackground : disabledBackground,
          foregroundColor: enabled ? enabledText : disabledText,
          elevation: enabled ? 4 : 0,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          l10n.next,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Amaranth',
          ),
        ),
      ),
    );
  }
}
