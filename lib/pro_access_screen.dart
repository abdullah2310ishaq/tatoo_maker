import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/usage_limit_provider.dart';
import 'services/admob_ids.dart';
import 'services/app_open_ad_service.dart';
import 'services/billing_service.dart';
import 'services/remote_config_service.dart';
import 'utils/colors.dart';
import 'widgets/interstitial_ad_loading_dialog.dart';

class ProAccessScreen extends StatefulWidget {
  final Widget nextScreen;
  final bool showInterstitialOnClose;
  final bool goToNextScreenOnClose;
  final bool forceTrialEnabled;
  final bool lockTrialToggle;
  final bool alwaysShowTrialToggle;

  const ProAccessScreen({
    super.key,
    required this.nextScreen,
    this.showInterstitialOnClose = false,
    this.goToNextScreenOnClose = false,
    this.forceTrialEnabled = false,
    this.lockTrialToggle = false,
    this.alwaysShowTrialToggle = true,
  });

  @override
  State<ProAccessScreen> createState() => _ProAccessScreenState();
}

class _ProAccessScreenState extends State<ProAccessScreen> {
  late final PageController _pageController;
  late final Timer _sliderTimer;
  late final BillingService _billingService;

  InterstitialAd? _closeInterstitialAd;
  bool _isCloseInterstitialLoadStarted = false;

  Timer? _closeButtonTimer;
  StreamSubscription<BillingPurchaseEvent>? _billingEventsSubscription;

  int _index = 0;
  bool _canClose = false;
  bool _isPurchasing = false;
  bool _isBillingReady = false;
  bool _isClosing = false;
  PlanVariant _selectedPlan = PlanVariant.lifetime;
  bool get _isTrialEnabled => _selectedPlan == PlanVariant.freeTrial;

  void _log(String message) {
    debugPrint('[ProAccessScreen] $message');
  }

  final List<String> _images = const [
    'assets/in_app/in_appone.png',
    'assets/in_app/in_apptwo.png',
    'assets/in_app/in_appthree.png',
    'assets/in_app/in_appfour.png',
    'assets/in_app/in_appfive.png',
  ];

  @override
  void initState() {
    super.initState();
    _log('initState: screen opened.');
    AppOpenAdService.instance.setTemporarilyDisabled(true);

    _pageController = PageController();
    _billingService = BillingService();
    if (widget.forceTrialEnabled) {
      _selectedPlan = PlanVariant.freeTrial;
    }

    _sliderTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;

      _index = (_index + 1) % _images.length;

      _pageController.animateToPage(
        _index,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });

    _closeButtonTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _canClose = true;
      });
    });

    if (widget.showInterstitialOnClose) {
      _preloadCloseInterstitial();
    }
    _initializeBilling();
  }

  @override
  void dispose() {
    AppOpenAdService.instance.setTemporarilyDisabled(false);
    _sliderTimer.cancel();
    _closeButtonTimer?.cancel();
    _billingEventsSubscription?.cancel();
    _closeInterstitialAd?.dispose();
    _closeInterstitialAd = null;
    unawaited(_billingService.dispose());
    _pageController.dispose();
    super.dispose();
  }

  void _preloadCloseInterstitial() {
    if (_isCloseInterstitialLoadStarted) return;
    _isCloseInterstitialLoadStarted = true;

    final unitId = AdmobIds.interstitialUnitId().trim();
    if (unitId.isEmpty) return;

    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _log('Close interstitial preloaded.');
          _closeInterstitialAd?.dispose();
          _closeInterstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _log('Close interstitial preload failed: $error');
        },
      ),
    );
  }

  void _goNext() {
    _log('Navigating to next screen after billing flow.');
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextScreen));
  }

  Future<void> _closeScreen() async {
    if (_isClosing) return;
    _isClosing = true;
    try {
      if (widget.showInterstitialOnClose) {
        await _showInterstitialOnCloseIfAvailable();
      }
    } finally {
      if (!mounted) return;
      _isClosing = false;
    }

    final navigator = Navigator.of(context);
    if (widget.goToNextScreenOnClose) {
      _goNext();
      return;
    }
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }
    _goNext();
  }

  Future<void> _showInterstitialOnCloseIfAvailable() async {
    final unitId = AdmobIds.interstitialUnitId().trim();
    if (unitId.isEmpty) return;

    // If we already have a cached interstitial (preloaded in initState),
    // show it immediately so the "first close" doesn't feel like it skipped.
    final cachedAd = _closeInterstitialAd;
    if (cachedAd != null) {
      _closeInterstitialAd = null;
      final completer = Completer<void>();
      final loadingHandle = await showInterstitialAdLoadingDialog(
        context,
        minShowDuration: const Duration(seconds: 2),
        safetyTimeout: const Duration(seconds: 4),
      );
      cachedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadingHandle.close();
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _log('Interstitial failed to show on close: $error');
          loadingHandle.close();
          if (!completer.isCompleted) completer.complete();
        },
      );
      try {
        _log('close interstitial: waiting 2s loading dialog (cached ad)...');
        await loadingHandle.waitForMinShowDuration();
        _log('close interstitial: showing cached interstitial now');
        await Future<void>.delayed(const Duration(milliseconds: 150));
        cachedAd.show();
      } catch (error) {
        cachedAd.dispose();
        _log('Interstitial show threw on close: $error');
        loadingHandle.close();
        if (!completer.isCompleted) completer.complete();
      }

      try {
        await completer.future.timeout(const Duration(seconds: 4));
      } on TimeoutException {
        _log('Interstitial timeout on close; continuing.');
      }
      return;
    }

    final completer = Completer<void>();
    final loadingHandle = await showInterstitialAdLoadingDialog(
      context,
      minShowDuration: const Duration(seconds: 2),
      safetyTimeout: const Duration(seconds: 4),
    );
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _log('Interstitial failed to show on close: $error');
              loadingHandle.close();
              if (!completer.isCompleted) completer.complete();
            },
          );
          try {
            _log(
              'close interstitial: waiting 2s loading dialog (fresh load)...',
            );
            await loadingHandle.waitForMinShowDuration();
            _log('close interstitial: showing interstitial now');
            await Future<void>.delayed(const Duration(milliseconds: 150));
            ad.show();
          } catch (error) {
            ad.dispose();
            _log('Interstitial show threw on close: $error');
            loadingHandle.close();
            if (!completer.isCompleted) completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          _log('Interstitial failed to load on close: $error');
          loadingHandle.close();
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 4));
    } on TimeoutException {
      _log('Interstitial timeout on close; continuing.');
      loadingHandle.close();
    }
  }

  Future<void> _initializeBilling() async {
    _log('Initializing billing service...');
    try {
      await _billingService.initialize();
    } catch (error, stackTrace) {
      debugPrint('[ProAccessScreen] Billing initialize failed: $error');
      debugPrint('[ProAccessScreen] Billing init stack trace: $stackTrace');
    }
    if (!mounted) return;

    _billingEventsSubscription = _billingService.purchaseEvents.listen(
      _onBillingEvent,
    );

    final trialProduct = _billingService.productForPlan(BillingPlan.freeTrial);
    final lifetimeProduct = _billingService.productForPlan(
      BillingPlan.lifetime,
    );
    _log(
      'Billing products => '
      'trial=${trialProduct?.id}:${_billingService.displayPriceForPlan(BillingPlan.freeTrial)}, '
      'lifetime=${lifetimeProduct?.id}:${_billingService.displayPriceForPlan(BillingPlan.lifetime)}',
    );

    setState(() {
      _isBillingReady =
          _billingService.isStoreAvailable && _billingService.hasProducts;
    });
    _log('Billing ready=$_isBillingReady');
  }

  String _freeTrialDisplayPrice(AppLocalizations l10n) {
    final maxPrice = _billingService.weeklyPaidMaxPrice();
    if (maxPrice == null || maxPrice.isEmpty) {
      return l10n.proAccessPlanWeeklyPrice;
    }
    return l10n.proAccessWeeklyPriceWithPeriod(maxPrice);
  }

  String _lifetimeDisplayPrice() {
    return _billingService.displayPriceForPlan(BillingPlan.lifetime) ?? '--';
  }

  String _lifetimePerWeekDisplayPrice() {
    final lifetimeProduct = _billingService.productForPlan(
      BillingPlan.lifetime,
    );
    if (lifetimeProduct == null) return '--';

    final perWeekRawPrice = lifetimeProduct.rawPrice / 52;
    final truncated = perWeekRawPrice.floorToDouble();
    try {
      return NumberFormat.simpleCurrency(
        name: lifetimeProduct.currencyCode,
        decimalDigits: 0,
      ).format(truncated);
    } catch (_) {
      // Fallback: if currency formatting fails on this device/locale.
      try {
        return NumberFormat.currency(
          name: lifetimeProduct.currencyCode,
          decimalDigits: 0,
        ).format(truncated);
      } catch (_) {
        return '--';
      }
    }
  }

  String _bottomFooterText(AppLocalizations l10n) {
    if (_selectedPlan == PlanVariant.lifetime) {
      final lifetimePrice = _lifetimeDisplayPrice();
      if (lifetimePrice == '--') {
        return l10n.proAccessLifetimeLegalNoPrice;
      }
      return l10n.proAccessLifetimeLegalWithPrice(lifetimePrice);
    }
    return l10n.proAccessLegalNote(_freeTrialDisplayPrice(l10n));
  }

  String _preCtaText(AppLocalizations l10n) {
    if (_selectedPlan == PlanVariant.freeTrial) {
      return l10n.proAccessAutoRenewableCancelAnytime;
    }
    return l10n.proAccessCancelAnytime;
  }

  void _selectPlan(PlanVariant plan) {
    if (_selectedPlan == plan) return;
    _log('Plan selected: $plan');
    setState(() {
      _selectedPlan = plan;
    });
  }

  void _onTrialToggleChanged(bool isEnabled) {
    final nextPlan = isEnabled ? PlanVariant.freeTrial : PlanVariant.lifetime;
    _log('Enable trial toggled: $isEnabled');
    _selectPlan(nextPlan);
  }

  BillingPlan _toBillingPlan(PlanVariant variant) {
    switch (variant) {
      case PlanVariant.freeTrial:
        return BillingPlan.freeTrial;
      case PlanVariant.lifetime:
        return BillingPlan.lifetime;
    }
  }

  void _onBillingEvent(BillingPurchaseEvent event) {
    if (!mounted) return;
    _log(
      'Billing event => status=${event.status}, productId=${event.productId}',
    );

    switch (event.status) {
      case BillingPurchaseStatus.pending:
        setState(() {
          _isPurchasing = true;
        });
        break;
      case BillingPurchaseStatus.purchased:
        unawaited(context.read<UsageLimitProvider>().unlockPro());
        _goNext();
        break;
      case BillingPurchaseStatus.canceled:
      case BillingPurchaseStatus.error:
        setState(() {
          _isPurchasing = false;
        });
        break;
    }
  }

  Future<void> _onContinuePressed() async {
    if (_isPurchasing) return;
    _log('Continue tapped. selectedPlan=$_selectedPlan');

    // While IDs are placeholders, purchase might fail to launch.
    if (!_isBillingReady) {
      _log('Billing not ready. Keeping user on paywall.');
      return;
    }

    // Only show progress when we're actually attempting a purchase.
    setState(() {
      _isPurchasing = true;
    });

    final bool started = await _billingService.purchasePlan(
      _toBillingPlan(_selectedPlan),
    );
    if (!mounted) return;

    if (!started) {
      _log('Purchase did not start. Keeping user on paywall.');
      setState(() {
        _isPurchasing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(_closeScreen());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isArabic =
                  Localizations.localeOf(context).languageCode == 'ar';
              final bottomSafeInset = MediaQuery.paddingOf(context).bottom;
              // Slight lift from bottom edge (static on all devices).
              final blockLiftFromBottom = 18.h;
              final maxPaywallScrollHeight =
                  constraints.maxHeight - bottomSafeInset - blockLiftFromBottom;
              // Shorter hero image (static ratio on all devices).
              final imageHeight = constraints.maxHeight * 0.55;
              const titleFontSize = 40.0;
              const subtitleFontSize = 20.0;
              final planVerticalPadding = 12.h;
              final trialToggleVerticalPadding = 5.h;
              final horizontalPadding = 20.w;
              // Fixed gaps — one connected block from title to legal text.
              final gapSm = 6.h;
              final gapMd = 8.h;
              final gapPlansToCta = 10.h;

              Widget buildTitleRow() {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.proAccessTitleGet,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isArabic ? 36.sp : titleFontSize.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                          fontFamily: 'Antonio',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: AppColors.darkPrimary,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          l10n.proAccessTitlePro,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isArabic ? 36.sp : titleFontSize.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                            fontFamily: 'Antonio',
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        l10n.proAccessTitleAccess,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isArabic ? 36.sp : titleFontSize.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                          fontFamily: 'Antonio',
                        ),
                      ),
                    ],
                  ),
                );
              }

              Widget buildConnectedPaywallBlock() {
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    8.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTitleRow(),
                      SizedBox(height: gapSm),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.proAccessSubtitle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: subtitleFontSize.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                            fontFamily: 'Antonio',
                          ),
                        ),
                      ),
                      SizedBox(height: gapMd),
                      _FeatureRow(
                        text: l10n.proAccessFeatureUnlimitedTattooCreation,
                      ),
                      _FeatureRow(
                        text: l10n.proAccessFeatureFastProcessing,
                      ),
                      _FeatureRow(
                        text: l10n.proAccessFeatureUnlockAllStyles,
                      ),
                      _FeatureRow(
                        text: l10n.proAccessFeatureRemoveWatermarks,
                      ),
                      SizedBox(height: gapMd),
                      if (widget.alwaysShowTrialToggle ||
                          context
                              .watch<RemoteConfigService>()
                              .proAccessShowTrialToggle) ...[
                        _TrialToggleCard(
                          isEnabled: _isTrialEnabled,
                          onChanged: widget.lockTrialToggle
                              ? null
                              : _onTrialToggleChanged,
                          verticalPadding: trialToggleVerticalPadding,
                        ),
                        SizedBox(height: gapMd),
                      ],
                      _PlanCard(
                        variant: PlanVariant.freeTrial,
                        leftText: '3-Day Full Access',
                        leftSubText:
                            'then ${_billingService.weeklyPaidMaxPrice() ?? '--'}/week',
                        leftSubTextColor: AppColors.textGrey.withOpacity(0.85),
                        rightText: _billingService.weeklyPaidMinPrice() ?? '--',
                        rightSubText: 'per week',
                        showBadge: true,
                        badgeText: l10n.proAccessLifetimeDiscountBadge,
                        verticalPadding: planVerticalPadding,
                        isSelected: _selectedPlan == PlanVariant.freeTrial,
                        onTap: () {
                          _selectPlan(PlanVariant.freeTrial);
                        },
                      ),
                      SizedBox(height: gapSm),
                      _PlanCard(
                        variant: PlanVariant.lifetime,
                        leftText: 'Yearly',
                        leftSubText: 'just ${_lifetimeDisplayPrice()} per year',
                        leftSubTextColor: AppColors.textGrey.withOpacity(0.85),
                        rightText: _lifetimePerWeekDisplayPrice(),
                        rightSubText: 'per week',
                        verticalPadding: planVerticalPadding,
                        isSelected: _selectedPlan == PlanVariant.lifetime,
                        onTap: () {
                          _selectPlan(PlanVariant.lifetime);
                        },
                      ),
                      SizedBox(height: gapPlansToCta),
                      Text(
                        _preCtaText(l10n),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey.withOpacity(0.85),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isPurchasing ? null : _onContinuePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: _isPurchasing
                              ? SizedBox(
                                  width: 22.sp,
                                  height: 22.sp,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.textWhite,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        (_selectedPlan == PlanVariant.freeTrial
                                                ? l10n.proAccessContinueForFree
                                                : l10n.continue_)
                                            .toUpperCase(),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: _selectedPlan ==
                                                  PlanVariant.freeTrial
                                              ? 16.sp
                                              : 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textWhite,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.textWhite,
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _bottomFooterText(l10n),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey.withOpacity(0.85),
                          height: 1.35,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  /// BASE (area below shorter image)
                  Positioned.fill(
                    child: ColoredBox(color: AppColors.darkBackground),
                  ),

                  /// HERO IMAGE (shorter height, top-aligned)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: imageHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Image.asset(
                              _images[index],
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.darkBackground,
                                );
                              },
                            );
                          },
                        ),
                        // Dim at bottom edge where image ends
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x00000000),
                                Color(0x00000000),
                                Color(0x80000000),
                                Color(0xE6000000),
                                Color(0xFF000000),
                              ],
                              stops: const [0.0, 0.5, 0.78, 0.92, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// GRADIENT for paywall text readability (fixed on all screens)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x00000000),
                            Color(0x44000000),
                            Color(0xCC000000),
                            Color(0xFF000000),
                          ],
                          stops: const [0.0, 0.42, 0.72, 1.0],
                        ),
                      ),
                    ),
                  ),

                  /// ONE CONNECTED BLOCK: title → plans → CTA (anchored to bottom)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: blockLiftFromBottom),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: maxPaywallScrollHeight,
                          ),
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: buildConnectedPaywallBlock(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// CLOSE BUTTON (keep on top so taps are never blocked)
                  Positioned(
                    top: 12.h,
                    left: 16.w,
                    child: IgnorePointer(
                      ignoring: !_canClose,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: _canClose ? 1 : 0,
                        child: IconButton(
                          onPressed: _closeScreen,
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.all(8.w),
                            minimumSize: Size(42.w, 42.w),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            Icons.close,
                            color: AppColors.textWhite,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

enum PlanVariant { freeTrial, lifetime }

class _TrialToggleCard extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final double verticalPadding;

  const _TrialToggleCard({
    required this.isEnabled,
    required this.onChanged,
    this.verticalPadding = 7,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.proAccessOptionBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isEnabled
                  ? l10n.proAccessTrialEnabled
                  : l10n.proAccessEnableTrial,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textWhite,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: AppColors.textWhite,
            activeTrackColor: AppColors.darkPrimary,
            inactiveThumbColor: AppColors.textWhite,
            inactiveTrackColor: AppColors.darkBackground.withOpacity(0.45),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PlanVariant variant;
  final String leftText;
  final String? leftSubText;
  final Color? leftSubTextColor;
  final String? rightText;
  final String? rightSubText;
  final bool showBadge;
  final String? badgeText;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? verticalPadding;

  const _PlanCard({
    required this.variant,
    required this.leftText,
    this.leftSubText,
    this.leftSubTextColor,
    this.rightText,
    this.rightSubText,
    this.showBadge = false,
    this.badgeText,
    this.isSelected = false,
    this.onTap,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isSelected ? 16.w : 15.w;
    final resolvedVerticalPadding =
        (verticalPadding ?? 13.h) + (isSelected ? 2.h : 0);
    final leftTextSize = isSelected ? 14.sp : 13.sp;
    final rightTextSize = isSelected ? 13.sp : 12.sp;
    final borderColor = isSelected
        ? AppColors.darkPrimary
        : AppColors.navBarBackground.withOpacity(0);
    final borderWidth = isSelected ? 1.0.w : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: resolvedVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkBackground.withOpacity(0.01)
              : AppColors.proAccessOptionBackground,
          borderRadius: BorderRadius.circular(isSelected ? 4.r : 4.r),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leftText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: leftTextSize,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.darkPrimary
                              : AppColors.textWhite,
                          fontFamily: 'Inter',
                        ),
                      ),
                      if (leftSubText != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          leftSubText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: leftSubTextColor ??
                                AppColors.textGrey.withOpacity(0.85),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (rightText != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 86.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rightText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: rightTextSize,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.textGrey.withOpacity(0.95),
                            fontFamily: 'Inter',
                          ),
                        ),
                        if (rightSubText != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            rightSubText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textGrey.withOpacity(0.85),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
            if (showBadge)
              Positioned(
                top: -19.h,
                right: -3.w,
                child: IgnorePointer(child: _DiscountBadge(text: badgeText)),
              ),
          ],
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = (text == null || text!.trim().isEmpty)
        ? l10n.proAccessLifetimeDiscountBadge
        : text!.trim();

    return SizedBox(
      width: 32.w,
      height: 16.h,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.proBadgeBackground,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textWhite,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowWidth = constraints.maxWidth * 0.55;

          return SizedBox(
            width: rowWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 11.sp,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                      fontFamily: 'Antonio',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
