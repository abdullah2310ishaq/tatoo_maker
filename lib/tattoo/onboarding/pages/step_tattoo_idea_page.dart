import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/usage_limit_provider.dart';
import '../../../services/admob_ids.dart';
import '../../../services/remote_config_service.dart';
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

class _StepTattooIdeaPageState extends State<StepTattooIdeaPage>
    with WidgetsBindingObserver {
  static const int _maxCharacters = 500;
  final FocusNode _ideaFocusNode = FocusNode();
  bool _keyboardVisibleByMetrics = false;
  bool _bannerVisible = false;
  bool _nativeVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_handleTextChanged);
    _syncKeyboardVisibility();
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
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_handleTextChanged);
    _ideaFocusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _syncKeyboardVisibility();
  }

  void _syncKeyboardVisibility() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return;
    final keyboardVisible = views.first.viewInsets.bottom > 0.0;
    if (keyboardVisible == _keyboardVisibleByMetrics) return;

    if (!mounted) {
      _keyboardVisibleByMetrics = keyboardVisible;
      return;
    }

    setState(() {
      _keyboardVisibleByMetrics = keyboardVisible;
    });
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
    final keyboardOpen =
        MediaQuery.of(context).viewInsets.bottom > 0 ||
        _keyboardVisibleByMetrics;
    final isWriting = keyboardOpen;

    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    final shouldShowBanner = !isPro && rc.tattooIdeaShowBanner;
    final shouldShowNative = !isPro && rc.tattooIdeaShowNative;

    // If Remote Config/Pro disables ads while we previously marked them visible,
    // reset state after this frame so the "no ads" layout has no gaps.
    if (!shouldShowBanner && _bannerVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_bannerVisible) setState(() => _bannerVisible = false);
      });
    }
    if (!shouldShowNative && _nativeVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_nativeVisible) setState(() => _nativeVisible = false);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingHeader(
                  currentStep: 4,
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
        if (!isWriting) ...[
          // Bottom ads (no reserved space when not loaded).
          // Order: Banner first, then Native. Gap only when both visible.
          if (shouldShowBanner)
            _TattooIdeaBannerAd(
              onVisibilityChanged: (visible) {
                if (_bannerVisible == visible) return;
                setState(() => _bannerVisible = visible);
              },
            ),
          if (shouldShowNative) ...[
            if (_bannerVisible && _nativeVisible) SizedBox(height: 8.h),
            _TattooIdeaNativeAd(
              isDark: isDark,
              onVisibilityChanged: (visible) {
                if (_nativeVisible == visible) return;
                setState(() => _nativeVisible = visible);
              },
            ),
          ],
          SafeArea(top: false, child: SizedBox(height: 8.h)),
        ] else ...[
          SafeArea(top: false, child: SizedBox(height: 12.h)),
        ],
      ],
    );
  }
}

class _TattooIdeaBannerAd extends StatefulWidget {
  const _TattooIdeaBannerAd({required this.onVisibilityChanged});

  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_TattooIdeaBannerAd> createState() => _TattooIdeaBannerAdState();
}

class _TattooIdeaBannerAdState extends State<_TattooIdeaBannerAd> {
  BannerAd? _ad;
  int _loadedWidth = 0;
  bool _loaded = false;
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadIfEligibleForCurrentWidth();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadIfEligibleForCurrentWidth();
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onVisibilityChanged(visible);
    });
  }

  Future<void> _loadIfEligibleForCurrentWidth() async {
    if (!mounted) return;
    final rc = context.read<RemoteConfigService>();
    final isPro = context.read<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowBanner) return;

    final width = MediaQuery.of(context).size.width.truncate();
    if (width <= 0) return;
    if (_loadedWidth == width && _ad != null) return;
    _loadedWidth = width;

    await _loadAdaptive(unitId: AdmobIds.bannerUnitId(), width: width);
  }

  Future<void> _loadAdaptive({
    required String unitId,
    required int width,
  }) async {
    final normalizedUnitId = unitId.trim();
    if (normalizedUnitId.isEmpty) return;
    final adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (adaptiveSize == null) return;

    _ad?.dispose();
    _ad = null;
    if (mounted && _loaded) {
      setState(() {
        _loaded = false;
      });
    }

    final ad = BannerAd(
      adUnitId: normalizedUnitId,
      request: const AdRequest(),
      size: adaptiveSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _ad = ad as BannerAd;
            _loaded = true;
          });
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
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
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowBanner) {
      _emit(false);
      return const SizedBox.shrink();
    }

    final ad = _ad;
    if (!_loaded || ad == null) {
      _emit(false);
      return const SizedBox.shrink();
    }

    _emit(true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          top: false,
          child: Center(
            child: SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}

class _TattooIdeaNativeAd extends StatefulWidget {
  const _TattooIdeaNativeAd({
    required this.isDark,
    required this.onVisibilityChanged,
  });

  final bool isDark;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_TattooIdeaNativeAd> createState() => _TattooIdeaNativeAdState();
}

class _TattooIdeaNativeAdState extends State<_TattooIdeaNativeAd> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _lastEmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final rc = context.read<RemoteConfigService>();
      final isPro = context.read<UsageLimitProvider>().isProUnlocked;
      if (isPro || !rc.tattooIdeaShowNative) return;
      _load();
    });
  }

  @override
  void didUpdateWidget(covariant _TattooIdeaNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark == widget.isDark) return;
    _ad?.dispose();
    _ad = null;
    _loaded = false;
    _emit(false);
    _load();
  }

  void _emit(bool visible) {
    if (_lastEmitted == visible) return;
    _lastEmitted = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onVisibilityChanged(visible);
    });
  }

  void _load() {
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
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _ad = null;
            _loaded = false;
          });
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
    final rc = context.watch<RemoteConfigService>();
    final isPro = context.watch<UsageLimitProvider>().isProUnlocked;
    if (isPro || !rc.tattooIdeaShowNative) {
      _emit(false);
      return const SizedBox.shrink();
    }

    final ad = _ad;
    if (!_loaded || ad == null) {
      _emit(false);
      return const SizedBox.shrink();
    }

    _emit(true);

    final cardColor = widget.isDark
        ? AppColors.inputCardDarkBackground
        : AppColors.lightBackground;
    final radius = BorderRadius.circular(14.r);
    final slotHeight = 138.h;

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
