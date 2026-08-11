import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/usage_limit_provider.dart';
import 'services/admob_ids.dart';
import 'services/app_open_ad_service.dart';
import 'services/billing_service.dart';
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

    final unitId = AdIds.testInterId.trim();
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
    final unitId = AdIds.testInterId.trim();
    if (unitId.isEmpty) return;

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
    _log(
      'Billing products => '
          'trial=${trialProduct?.id}:${_billingService.displayPriceForPlan(BillingPlan.freeTrial)}',
    );

    setState(() {
      _isBillingReady =
          _billingService.isStoreAvailable && _billingService.hasProducts;
    });
    _log('Billing ready=$_isBillingReady');
  }

  String _weeklySubscriptionPrice() {
    return _billingService.weeklyPaidMaxPrice() ??
        _billingService.displayPriceForPlan(BillingPlan.freeTrial) ??
        '--';
  }

  String _bottomFooterText() {
    final price = _weeklySubscriptionPrice();
    return 'After 3 days free - then weekly subscription for $price will start. Cancel anytime 24 hours before renewal';
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
    _log('Continue tapped for free trial plan.');

    if (!_isBillingReady) {
      _log('Billing not ready. Keeping user on paywall.');
      return;
    }

    setState(() {
      _isPurchasing = true;
    });

    final bool started = await _billingService.purchasePlan(
      BillingPlan.freeTrial,
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
              final blockLiftFromBottom = 18.h;
              final maxPaywallScrollHeight =
                  constraints.maxHeight - bottomSafeInset - blockLiftFromBottom;
              final imageHeight = constraints.maxHeight * 0.55;
              const titleFontSize = 40.0;
              const subtitleFontSize = 20.0;
              final horizontalPadding = 20.w;
              final gapSm = 6.h;
              final gapMd = 8.h;
              final gapFeaturesToCta = 16.h;

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
                          'Unleash your creativity with PRO',
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
                      const _FeatureRow(
                        text: 'Unlimited tattoo creation',
                      ),
                      const _FeatureRow(
                        text: 'Fast processing',
                      ),
                      const _FeatureRow(
                        text: 'Unlock all styles',
                      ),
                      const _FeatureRow(
                        text: 'Remove watermarks',
                      ),
                      SizedBox(height: gapFeaturesToCta),
                      Text(
                        l10n.proAccessAutoRenewableCancelAnytime,
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
                                  'CONTINUE FOR FREE',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
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
                        _bottomFooterText(),
                        textAlign: TextAlign.center,
                        maxLines: 3,
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
                  Positioned.fill(
                    child: ColoredBox(color: AppColors.darkBackground),
                  ),
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
