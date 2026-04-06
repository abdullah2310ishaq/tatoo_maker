import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatoo_maker/providers/usage_limit_provider.dart';
import 'package:tatoo_maker/services/billing_service.dart';
import 'package:tatoo_maker/pro_access_screen.dart';
import 'utils/colors.dart';
import 'home_shell.dart';
import 'language/first_language.dart';

class SplashScreen extends StatefulWidget {
  final bool isDarkTheme;

  const SplashScreen({super.key, this.isDarkTheme = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _introController;

  late final BillingService _billingService;
  StreamSubscription<BillingPurchaseEvent>? _billingEventsSubscription;

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

    _billingService = BillingService();

    // Start async work only after first frame so Provider/Navigator are ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_restorePurchasesInBackground());
      unawaited(_checkOnboardingStatus());
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
    await Future.delayed(const Duration(seconds: 3));
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
        // First time - go to language selection
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstLanguageScreen()),
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

  @override
  void dispose() {
    _billingEventsSubscription?.cancel();
    unawaited(_billingService.dispose());
    _introController.dispose();
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
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: const _SplashTitle(),
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
