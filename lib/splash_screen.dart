import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/providers/usage_limit_provider.dart';
import 'package:tatoo_maker/services/app_open_ad_service.dart';
import 'package:tatoo_maker/services/billing_service.dart';
import 'package:tatoo_maker/services/admob_ids.dart';
import 'package:tatoo_maker/services/remote_config_service.dart';
import 'package:tatoo_maker/services/ad_mode.dart';
import 'package:tatoo_maker/pro_access_screen.dart';
import 'package:tatoo_maker/l10n/app_localizations.dart';
import 'utils/colors.dart';
import 'home_shell.dart';
import 'language/first_language.dart';
import 'real_onboarding/real_onboarding_flow.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkTheme;

  const SplashScreen({super.key, this.isDarkTheme = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _introController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  late final BillingService _billingService;
  StreamSubscription<BillingPurchaseEvent>? _billingEventsSubscription;

  bool _shouldShowSplashAdText = false;

  static const String _prefsSplashHasRunBeforeKey = 'splash_has_run_before';

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic),
        );

    _introController.forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _progressAnimation = _progressController.drive(
      Tween<double>(begin: 0.0, end: 1.0),
    );

    _billingService = BillingService();

    // Start async work only after first frame so Provider/Navigator are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_restorePurchasesInBackground());
      unawaited(_runSplashSequence());
    });
  }

  Future<void> _restorePurchasesInBackground() async {
    try {
      if (!mounted) return;

      // Reset local entitlement on launch; restore will re-unlock if active.
      await context.read<UsageLimitProvider>().setProUnlocked(false);
      // help me to understand this code
      // this code is used to initialize the billing service and restore purchases
      // the billing service is used to purchase and restore purchases
      // the billing service is used to get the products and prices
      // the billing service is used to get the purchase events
      // the billing service is used to get the purchase details
      // the billing service is used to get the purchase status
      // the billing service is used to get the purchase error
      // the billing service is used to get the purchase stack trace
      // the billing service is used to get the purchase time
      // the billing service is used to get the purchase date
      // the billing service is used to get the purchase amount
      // the billing service is used to get the purchase currency
      // the billing service is used to get the purchase currency code
      // the billing service is used to get the purchase currency symbol
      // the billing service is used to get the purchase currency symbol code
      await _billingService.initialize();
      _billingEventsSubscription = _billingService.purchaseEvents.listen((
        event,
      ) {
        if (!mounted) return;
        if (event.status != BillingPurchaseStatus.purchased) return;

        if (event.productId == kProLifetimeProductId ||
            event.productId == kProTrial3DaysProductId) {
          unawaited(context.read<UsageLimitProvider>().unlockPro());
        }
      });

      await _billingService.restorePurchases();
    } catch (_) {
      // Restore should never block app entry.
    }
  }

  Future<void> _checkOnboardingStatus() async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingCompleted =
          prefs.getBool('onboarding_completed') ?? false;

      if (!mounted) return;

      if (isOnboardingCompleted) {
        // User has completed onboarding.
        // Show in-app screen after splash (if not Pro); then continue to Home.
        final usage = context.read<UsageLimitProvider>();
        final next = usage.isProUnlocked
            ? const HomeShell()
            : ProAccessScreen(nextScreen: const HomeShell());
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => next));
      } else {
        // First time - route controlled by Remote Config:
        // - when `firstLanguageOnboardingEnabled` is true => show language screen
        // - otherwise skip to main onboarding flow directly.
        final rc = context.read<RemoteConfigService>();
        final bool showLanguageScreen = rc.firstLanguageOnboardingEnabled;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => showLanguageScreen
                ? const FirstLanguageScreen()
                : const RealOnboardingFlow(),
          ),
        );
      }
    } catch (e) {
      // On error, assume first time and go to language selection
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstLanguageScreen()),
        );
      }
    }
  }

  Future<void> _runSplashSequence() async {
    // Keep the same min splash time as before (3 seconds) while optionally
    // showing full-screen ads after the first app open.
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRunBefore =
          prefs.getBool(_prefsSplashHasRunBeforeKey) ?? false;

      final rc = context.read<RemoteConfigService>();
      final adsAndTextEnabled = rc.splashAdsAndTextEnabled;
      // First-ever splash: no ad. Every splash after that: ad can be shown.
      final shouldAttemptAds = hasRunBefore && adsAndTextEnabled;

      if (kDebugMode) {
        debugPrint(
          '[SplashScreen] first-run check: hasRunBefore=$hasRunBefore, '
          'adsEnabled=$adsAndTextEnabled, showAppOpen=${rc.splashShowAppOpen}, '
          'showInterstitial=${rc.splashShowInterstitial}',
        );
      }

      if (mounted) {
        setState(() {
          _shouldShowSplashAdText = shouldAttemptAds;
        });
      }

      final Future<void> progressFuture = _progressController.forward(
        from: 0.0,
      );

      final Future<void> adsFuture = shouldAttemptAds
          ? _showSplashAds(
              showAppOpen: rc.splashShowAppOpen,
              showInterstitial: rc.splashShowInterstitial,
            )
          : Future<void>.value();

      await Future.wait([adsFuture, progressFuture]);

      if (!mounted) return;

      await prefs.setBool(_prefsSplashHasRunBeforeKey, true);

      await _checkOnboardingStatus();
    } catch (_) {
      if (!mounted) return;
      await _checkOnboardingStatus();
    }
  }

  Future<void> _showSplashAds({
    required bool showAppOpen,
    required bool showInterstitial,
  }) async {
    final rc = context.read<RemoteConfigService>();
    final appOpenUnitId = AdMode.useTestAds
        ? rc.admobAndroidAppOpenTestUnitId
        : rc.admobAndroidAppOpenUnitId;
    final interstitialUnitId = AdMode.useTestAds
        ? rc.admobAndroidInterstitialTestUnitId
        : rc.admobAndroidInterstitialUnitId;

    // Priority rule: If App Open is enabled, show it and skip interstitial.
    if (showAppOpen) {
      // Give the splash UI a moment to settle so App Open doesn't appear
      // "inside the app" after navigation has already started.
      await Future<void>.delayed(const Duration(seconds: 2));
      await _showAppOpenAdIfAvailable(
        unitIdOverride: appOpenUnitId,
        testUnitIdOverride: rc.admobAndroidAppOpenTestUnitId,
      );
      return;
    }
    if (showInterstitial) {
      await _showInterstitialAdIfAvailable(unitIdOverride: interstitialUnitId);
    }
  }

  Future<void> _showInterstitialAdIfAvailable({
    bool didRetry = false,
    String? unitIdOverride,
  }) async {
    final unitId = unitIdOverride ?? AdmobIds.interstitialUnitId();
    if (unitId.isEmpty) return;

    final testUnitId = AdmobIds.interstitialTestUnitId();
    int? errorCode;

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) {
              debugPrint('[SplashScreen] interstitial shown');
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              errorCode = error.code;
              debugPrint(
                '[SplashScreen] interstitial failed to show: $error',
              );
              if (!completer.isCompleted) completer.complete();
            },
          );
          try {
            ad.show();
          } catch (e) {
            ad.dispose();
            if (!completer.isCompleted) completer.complete();
          }
        },
        onAdFailedToLoad: (error) {
          errorCode = error.code;
          debugPrint('[SplashScreen] interstitial failed to load: $error');
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {
      // Avoid blocking splash navigation forever.
    }

    // Retry with test unit when the primary ID is misconfigured.
    if (!didRetry &&
        errorCode == 3 &&
        testUnitId.isNotEmpty &&
        testUnitId != unitId) {
      await _showInterstitialAdIfAvailable(
        didRetry: true,
        unitIdOverride: testUnitId,
      );
    }
  }

  Future<void> _showAppOpenAdIfAvailable({
    String? unitIdOverride,
    String? testUnitIdOverride,
  }) async {
    // Centralize AppOpen ads in one place to avoid race conditions:
    // SplashScreen + app resume must share the same instance.
    await AppOpenAdService.instance.showIfAvailable(
      unitIdOverride: unitIdOverride,
      testUnitIdOverride: testUnitIdOverride,
    );
  }

  @override
  void dispose() {
    _billingEventsSubscription?.cancel();
    unawaited(_billingService.dispose());
    _introController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = widget.isDarkTheme || Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.isDarkTheme
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: Container(
          decoration: BoxDecoration(
            gradient: widget.isDarkTheme
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkSplashStart, // #000000 at 8.17%
                      AppColors.darkSplashEnd.withOpacity(
                        0.0,
                      ), // rgba(45, 49, 54, 0) at 87.03%
                    ],
                    stops: const [0.0817, 0.8703],
                  )
                : null,
            color: widget.isDarkTheme ? null : AppColors.lightBackground,
          ),
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _SplashTitle(),
                  const SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, _) {
                      return SizedBox(
                        width: 34,
                        height: 34,
                        child: CircularProgressIndicator(
                          value: _progressAnimation.value,
                          strokeWidth: 3.2,
                          backgroundColor: AppColors.textGrey.withOpacity(
                            isDarkTheme ? 0.25 : 0.12,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.lightPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  if (_shouldShowSplashAdText)
                    Text(
                      AppLocalizations.of(context)!.splashAdMayShowNotice,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
                        letterSpacing: 0.2,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Text(
      'AI Tattoo',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        letterSpacing: 2,
        color: isDarkTheme ? AppColors.lightPrimary : AppColors.darkSecondary,
      ),
    );
  }
}
