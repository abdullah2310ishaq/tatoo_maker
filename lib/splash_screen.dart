import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/providers/usage_limit_provider.dart';
import 'package:tatoo_maker/services/admob_ids.dart';
import 'package:tatoo_maker/services/app_open_ad_service.dart';
import 'package:tatoo_maker/services/billing_service.dart';
import 'package:tatoo_maker/services/remote_config_service.dart';
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
  late final AnimationController _introController;
  late final AnimationController _progressController;

  late final BillingService _billingService;
  StreamSubscription<BillingPurchaseEvent>? _billingEventsSubscription;

  bool _shouldShowSplashAdText = false;

  static const String _prefsSplashHasRunBeforeKey = 'splash_has_run_before';
  static const String _prefsProUnlockedKey = 'usage_pro_unlocked';
  static const String _logTag = 'SplashScreen';

  static void _log(String message) {
    final tagged = '[$_logTag] $message';
    developer.log(tagged, name: _logTag);
    if (kDebugMode) {
      debugPrint(tagged);
    }
  }

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _introController.forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
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

      if (UsageLimitProvider.forceProForTesting) {
        await context.read<UsageLimitProvider>().setProUnlocked(true);
        return;
      }

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
      _log('onboarding_completed=$isOnboardingCompleted');

      if (!mounted) return;

      if (isOnboardingCompleted) {
        // User has completed onboarding.
        // Show in-app screen after splash (if not Pro); then continue to Home.
        final usage = context.read<UsageLimitProvider>();
        final rc = context.read<RemoteConfigService>();
        final shouldShowPaywall = rc.splashShowPaywall;
        final next = usage.isProUnlocked
            ? const HomeShell()
            : (shouldShowPaywall
                  ? ProAccessScreen(nextScreen: const HomeShell())
                  : const HomeShell());
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => next));
      } else {
        // First time - route controlled by Remote Config:
        // - when `firstLanguageOnboardingEnabled` is true => show language screen
        // - otherwise skip to main onboarding flow directly.
        final rc = context.read<RemoteConfigService>();
        final bool showLanguageScreen = rc.firstLanguageOnboardingEnabled;
        _log(
          'routing first-time user by Remote Config: '
          'firstLanguageOnboardingEnabled=$showLanguageScreen',
        );

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
      _log('check onboarding status failed: $e');
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
      final hasRunBefore = prefs.getBool(_prefsSplashHasRunBeforeKey) ?? false;
      final isProUnlocked = prefs.getBool(_prefsProUnlockedKey) ?? false;
      final forcePro = UsageLimitProvider.forceProForTesting;

      final rc = context.read<RemoteConfigService>();
      final adsAndTextEnabled = rc.splashAdsAndTextEnabled;
      // First-ever splash: no ad. Every splash after that: ad can be shown.
      final shouldAttemptAds =
          hasRunBefore && adsAndTextEnabled && !isProUnlocked && !forcePro;

      _log(
        'first-run/ad gate: '
        'hasRunBefore=$hasRunBefore, '
        'isPro=$isProUnlocked, '
        'forcePro=$forcePro, '
        'adsEnabled=$adsAndTextEnabled, '
        'showAppOpen=${rc.splashShowAppOpen}, '
        'showInterstitial=${rc.splashShowInterstitial}, '
        'shouldAttemptAds=$shouldAttemptAds',
      );

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
      _log('runSplashSequence failed, continuing to onboarding check');
      if (!mounted) return;
      await _checkOnboardingStatus();
    }
  }

  Future<void> _showSplashAds({
    required bool showAppOpen,
    required bool showInterstitial,
  }) async {
    final appOpenUnitId = AdmobIds.appOpenUnitId();
    final interstitialUnitId = AdmobIds.interstitialUnitId();
    _log(
      'showSplashAds called: showAppOpen=$showAppOpen, showInterstitial=$showInterstitial',
    );

    // Priority rule: If App Open is enabled, show it and skip interstitial.
    if (showAppOpen) {
      // Give the splash UI a moment to settle so App Open doesn't appear
      // "inside the app" after navigation has already started.
      await Future<void>.delayed(const Duration(seconds: 3));
      _log('attempting splash app-open ad...');
      await _showAppOpenAdIfAvailable(unitIdOverride: appOpenUnitId);
      _log('splash app-open flow complete.');
      return;
    }
    if (showInterstitial) {
      _log('attempting splash interstitial ad...');
      await _showInterstitialAdIfAvailable(unitIdOverride: interstitialUnitId);
      _log('splash interstitial flow complete.');
    }
  }

  Future<void> _showInterstitialAdIfAvailable({String? unitIdOverride}) async {
    final unitId = (unitIdOverride ?? '').trim();
    if (unitId.isEmpty) return;

    final completer = Completer<void>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) {
              _log('interstitial shown');
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _log('interstitial failed to show: $error');
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
          _log('interstitial failed to load: $error');
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    try {
      await completer.future.timeout(const Duration(seconds: 5));
    } catch (_) {
      // Avoid blocking splash navigation forever.
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
          child: Stack(
            children: [
              const Align(alignment: Alignment.center, child: _SplashTitle()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 58),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, _) {
                          return SizedBox(
                            width: 34,
                            height: 34,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.2,
                              backgroundColor: AppColors.textGrey.withOpacity(
                                0.0,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            AppLocalizations.of(context)!.splashAdMayShowNotice,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textGrey,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
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
    return Text(
      'AI Tattoo',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 46,
        letterSpacing: 1.6,
        color: AppColors.lightPrimary,
      ),
    );
  }
}
